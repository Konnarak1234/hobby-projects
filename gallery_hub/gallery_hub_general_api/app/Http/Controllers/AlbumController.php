<?php

namespace App\Http\Controllers;

use App\Models\Album;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;


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
                $coverImagePath = $request
                    ->file('cover_image')
                    // path in storage/app/private/...
                    ->store('albums/covers');
            }

            $album = Album::create([
                'uuid' => (string) Str::uuid(),
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
            ], 201);

        } catch (\Throwable $e) {

            // Remove image if database creation failed
            if ($coverImagePath !== null) {
                Storage::disk('local')->delete(
                    $coverImagePath
                );
            }

            Log::error('Album database creation failed', [
                'error' => $e->getMessage(),
            ]);

            return response()->json([
                'message' => 'Failed to create album.',
            ], 500);
        }
    }
}
