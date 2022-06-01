package com.genericstartup.PocketRecipes.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NewRecipeRequest {
    private String userId;
    private List<String> authors;
    private String name;
    private String photoURL;
    private List<String> directions;
    private List<String> ingredients;
    private List<String> ingredientNames;
}
