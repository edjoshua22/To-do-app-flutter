<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'status'  => 'success',
        'message' => 'Todo API is running.',
        'data'    => null,
    ]);
});
