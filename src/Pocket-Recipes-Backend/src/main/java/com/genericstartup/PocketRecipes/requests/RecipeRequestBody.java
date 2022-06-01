package com.genericstartup.PocketRecipes.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecipeRequestBody {
    private String userId;
    private String cookbookId;
    private String recipeId;
}
