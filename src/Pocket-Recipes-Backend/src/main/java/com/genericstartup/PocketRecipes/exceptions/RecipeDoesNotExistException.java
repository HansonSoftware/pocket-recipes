package com.genericstartup.PocketRecipes.exceptions;

public class RecipeDoesNotExistException extends Exception {
    public RecipeDoesNotExistException(String message) {
        super(message);
    }
}
