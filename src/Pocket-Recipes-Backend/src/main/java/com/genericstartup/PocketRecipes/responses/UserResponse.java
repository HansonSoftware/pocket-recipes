package com.genericstartup.PocketRecipes.responses;

import com.genericstartup.PocketRecipes.models.CookbookModel;
import com.genericstartup.PocketRecipes.models.RecipeModel;
import com.genericstartup.PocketRecipes.models.UserModel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private UserModel userModel;
    private List<RecipeModel> userOwnedRecipes;
    private List<CookbookModel> userOwnedCookbooks;
}
