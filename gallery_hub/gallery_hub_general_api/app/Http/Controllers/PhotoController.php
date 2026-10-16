<?php

namespace App\Http\Controllers;

use App\Models\Album;
use App\Models\Photo;
use Illuminate\Filesystem\FilesystemAdapter;
use Illuminate\Support\Facades\Gate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Nette\Utils\FileSystem;

// Importants operation on Laravel UploadedFile::class object
// => UploadedFile::class are auto return from $request->file() as single or [] of files, when client uploading files
// Down below are some important operations:
// STORE upload file to laravel storage: $file->store($path, $storage_type)
// GET Temporary File path: $file->getRealPath()
// GET File size: $file->getSize()
// GET File mime type: $file->getMimeType()
// GET File name: $file->getClientOriginalName()
// 

// mentally concept how Laravel DB::Transaction(callback) work:
// DB::beginTransaction();

// try {
//     $result = /* execute callback */;

//     DB::commit();

//     return $result;

// } catch (\Throwable $e) {
//     DB::rollBack();

//     throw $e;
// }




class PhotoController extends Controller
{
    public function index(Album $album) {

        // checking album ownership
        Gate::authorize('view', $album);

        $photos = $album->photos()->latest()->paginate(20);

        // return photos associated with album
        return response()->json([
            'message' => 'photos return succefully',
            'photos' => $photos,
        ]);
    }

    

    public function showPhoto(Photo $photo) {
        // implement it soon...
        Gate::authorize('view', $photo->album);

        /**  @var FilesystemAdapter $disk */ 
        $disk = Storage::disk('local');

        if(!$disk->exists($photo->file_path)) {
            return response()->json([
                'message' => 'Image not found'
            ], 404);
        }

        return $disk->response($photo->file_path); // response()->file($file->path($photo->file_path));
    }

    public function store(Request $request, Album $album) {
        
         // Verify that the authenticated user can update the album.
        Gate::authorize('update', $album);

        // Validate uploaded files and their metadata.
        $validated = $request->validate([
            'photos' => 'required|array|min:1|max:20',
            'photos.*' => 'required|image|mimes:jpg,jpeg,png,webp|max:5120',

            'titles' => 'nullable|array|max:20',
            'titles.*' => 'nullable|string|max:255',

            'descriptions' => 'nullable|array|max:20',
            'descriptions.*' => 'nullable|string|max:255',
        ]);

        $storedPaths = [];

        try {
            $createdPhotos = DB::transaction(function () use (
                $request,
                $album,
                $validated,
                &$storedPaths
            ) {
                // global $storedPaths
                $createdPhotos = [];

                foreach ($request->file('photos') as $index => $file) {

                    // Store file in private local storage.
                    $path = $file->store(
                        "albums/{$album->uuid}/photos",
                        'local'
                    );


                    if ($path === false) {
                        throw new \RuntimeException(
                            'Failed to store uploaded photo.'
                        );
                    }

                    // Track stored files for cleanup if something fails.
                    $storedPaths[] = $path;

                    // Read image dimensions.
                    $dimensions = getimagesize($file->getRealPath());

                    // Create photo database record.
                    // There are distintion between $album->photos, $album->photos()
                    // 1. $album->photos: return the collection of related Photo model
                    // 2. $album->photos(): return the Eloquent/relations, which can access to operation such as get(), create(), count()
                    $photo = $album->photos()->create([
                        'title' => $validated['titles'][$index] ?? null,
                        'description' => $validated['descriptions'][$index] ?? null,

                        'file_path' => $path,
                        'original_name' => $file->getClientOriginalName(),
                        'mime_type' => $file->getMimeType(),
                        'file_size' => $file->getSize(),

                        'width' => $dimensions !== false
                            ? $dimensions[0]
                            : null,

                        'height' => $dimensions !== false
                            ? $dimensions[1]
                            : null,
                    ]);

                    $createdPhotos[] = $photo;
                }

                return $createdPhotos;
            });

            return response()->json([
                'message' => 'Photos uploaded successfully.',
                'photos' => $createdPhotos,
            ], 201);

        } catch (\Throwable $e) {

            // Remove files if uploading or database creation fails.
            foreach ($storedPaths as $path) {
                try {
                    Storage::disk('local')->delete($path);
                } catch (\Throwable $cleanupError) {
                    Log::error('Failed to clean up uploaded photo', [
                        'path' => $path,
                        'error' => $cleanupError->getMessage(),
                    ]);
                }
            }

            Log::error('Photo upload failed', [
                'album_id' => $album->id,
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'message' => 'Failed to upload photos.',
            ], 500);
        }
        
    }

}

