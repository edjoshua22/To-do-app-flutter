<?php

namespace App\Http\Controllers;

use App\Models\Todo;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class TodoController extends Controller
{
    /**
     * GET /api/todos
     * Fetch all todos ordered by latest first.
     */
    public function index(): JsonResponse
    {
        $todos = Todo::orderBy('created_at', 'desc')->get();

        return response()->json([
            'status'  => 'success',
            'message' => 'Todos fetched successfully.',
            'data'    => $todos,
        ]);
    }

    /**
     * POST /api/todos
     * Create a new todo.
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'title'       => 'required|string|max:255',
                'description' => 'nullable|string',
                'is_completed' => 'sometimes|boolean',
            ]);
        } catch (ValidationException $e) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Validation failed.',
                'data'    => $e->errors(),
            ], 422);
        }

        $todo = Todo::create($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Todo created successfully.',
            'data'    => $todo,
        ], 201);
    }

    /**
     * PUT /api/todos/{id}
     * Update an existing todo (title, description, is_completed).
     */
    public function update(Request $request, int $id): JsonResponse
    {
        $todo = Todo::find($id);

        if (!$todo) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Todo not found.',
                'data'    => null,
            ], 404);
        }

        try {
            $validated = $request->validate([
                'title'        => 'sometimes|required|string|max:255',
                'description'  => 'nullable|string',
                'is_completed' => 'sometimes|boolean',
            ]);
        } catch (ValidationException $e) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Validation failed.',
                'data'    => $e->errors(),
            ], 422);
        }

        $todo->update($validated);

        return response()->json([
            'status'  => 'success',
            'message' => 'Todo updated successfully.',
            'data'    => $todo,
        ]);
    }

    /**
     * DELETE /api/todos/{id}
     * Delete a todo.
     */
    public function destroy(int $id): JsonResponse
    {
        $todo = Todo::find($id);

        if (!$todo) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Todo not found.',
                'data'    => null,
            ], 404);
        }

        $todo->delete();

        return response()->json([
            'status'  => 'success',
            'message' => 'Todo deleted successfully.',
            'data'    => null,
        ]);
    }
}
