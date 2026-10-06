<?php

namespace App\Http\Controllers;

use App\Models\Album;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

// some essential methods use to work with Laravel's storage::disk()
// suppose we work Laravel local's storage disk, which path point to 'storage/app/private' in app/filesystem.php
// EXIST : Storage::disk('local')->exists($path)
// MISSING : Storage::disk('local')->missing($path)
// DELETE : Storage::disk('local')->delete($path or [...$paths])
// READ : Storage::disk('local')->get($path)
// WRITE : Storage::disk('local')->put($path, <contents>)

// relate to files and folders information:
// SIZE : ->size($path)
// LAST UPDATE : ->lastModified($path)
// GET FILES IN DIRECTORY : ->files($path)
// CREATE DIRECTORY : ->makeDirectory($dir)
// DELETE DIRECTORY : ->deleteDirectory($dir)

class AlbumController extends Controller
{ 
    public function store(Request $request) {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string|max:500',
            'location' => 'nullable|string|max:255',
            'cover_image' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        $coverImagePath = null;

         try {
            // check if there is existing field call cover_image in $_FILE[]
            if ($request->hasFile('cover_image')) {
                // this statement, also could return exception when it fail
                $coverImagePath = $request
                    // return fileUpload object, that store temporary file
                    ->file('cover_image')
                    // path in storage/app/private/...
                    ->store('albums/covers', 'local');
            }

            $album = Album::create([
                'user_id' => $request->user()->id,
                'title' => $validated['title'],
                'description' =>
                    $validated['description'] ?? null,
                'location' =>
                    $validated['location'] ?? null,
                'cover_image' => $coverImagePath,
            ]);

            return response()->json([
                'message' => 'Album created successfully.',
                'album' => $album,
            ], 200);

        } catch (\Throwable $e) {

            // Remove image if database creation failed
            if ($coverImagePath !== null) {
                Storage::disk('local')->delete(
                    $coverImagePath
                );
            }
            
            // we log the error message from $e exception object instead of provide it directly to client, becuase:
            // => we don't want to expose sensitive information, such as database exception, which could contain table information
            Log::error('Album database creation failed', [
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'message' => 'Failed to create album.',
            ], 500);
        }
    }
}
