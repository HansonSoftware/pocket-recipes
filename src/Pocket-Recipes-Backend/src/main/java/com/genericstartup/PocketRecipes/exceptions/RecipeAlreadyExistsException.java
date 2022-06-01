package com.genericstartup.PocketRecipes.exceptions;

public class RecipeAlreadyExistsException extends Exception {
    public RecipeAlreadyExistsException(String message) {
        super(message);
    }
}
