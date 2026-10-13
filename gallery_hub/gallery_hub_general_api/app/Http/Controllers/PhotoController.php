<?php

namespace App\Http\Controllers;

use App\Models\Album;
use App\Models\Photo;
use Illuminate\Http\Request;

class PhotoController extends Controller
{
    public function index(Album $album) {
        $photos = Photo::where('album_id', $album->id)->latest()->get();

        // return photos associated with album
        return response()->json([
            'message' => 'photos return succefully',
            'photos' => $photos,
        ]);
    }

    public function store(Request $request) {
        
        // validate photos upload information
        $request->validate([
            'album_id' => 'required|string|min:36|max:36',
            'titles' => 'nullable|array|max:20',
            'descriptions' => 'nullable|array|max:20',
            'photos' => 'nullable|array|max:20',
        ]);

        // store photos data + handle the error + return successful/fail message
        try {
            
        } catch(\Throwable $e) {

        }
        
    }

}
