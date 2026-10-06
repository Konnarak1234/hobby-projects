<?php

use App\Http\Controllers\AlbumController;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Route;

// token issue and revoke:
// 1. create : $user->createToken(_tokenName, _accessible, _tokenExpiration);
// 2. delete all : $user->tokens->delete();
// 3. delete current access : $user->currentAccessToken->delete();

// some useful token-related property:
// 1. access all user's associated token : $user->tokens
// 2. access token in plain text: $user->plainTextToken 


// There are 2 ways to manage token expiration:
// 1. go directo to sanctum configuration file, and add expiration time directly to field call 'expiration'
// 2. issue the expiration time directly, when create token, by specify the third argument using laravel carbon

Route::post('/login', function (Request $request) {

    // if validation fails, 422 status will return with json message 
    $request->validate([
        'email' => 'required|email',
        'password' => 'required|min:8'
    ]);

    
    $user = User::where('email', $request->input('email'))->first();

    if(!$user || !Hash::check($request->input('password'), $user->password)) {
        return response()->json([
            'message' => 'Invalid Credentials',
        ], 401);
    }       
    
    $token = $user->createToken('mobile_flutter');

    return [
        'user' => $user,
        'token' => $token->plainTextToken,
    ];
    
});

Route::post('albums', [AlbumController::class, 'store'])->middleware('auth:sanctum');


