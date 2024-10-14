package com.genericstartup.PocketRecipes.controllers;

import com.genericstartup.PocketRecipes.models.RecipeModel;
import com.genericstartup.PocketRecipes.requests.NewRecipeRequest;
import com.genericstartup.PocketRecipes.requests.UpdateRecipeRequest;
import com.genericstartup.PocketRecipes.responses.MessageResponse;
import com.genericstartup.PocketRecipes.services.RecipeService;
import com.genericstartup.PocketRecipes.services.UserService;
import lombok.SneakyThrows;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class RecipeControllerTest {

    @Mock
    RecipeService recipeService;

    @Mock
    UserService userService;

    @InjectMocks
    RecipeController recipeController;

    private static final RecipeModel RECIPE_A = new RecipeModel("1", "1", List.of("author1", "author2"), "Recipe A", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"), 0);
    private static final RecipeModel RECIPE_B = new RecipeModel("2", "1", List.of("author1", "author2"), "Recipe B", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"), 0);

    private static final NewRecipeRequest NEW_RECIPE_REQUEST_A = new NewRecipeRequest("1", List.of("author1", "author2"), "Recipe A", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"));
    private static final UpdateRecipeRequest UPDATE_RECIPE_REQUEST_A = new UpdateRecipeRequest("1", "1", List.of("author1", "author2"), "Recipe A", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"));

    @SneakyThrows
    @Test
    void getAllRecipes_test() {
        Mockito.when(recipeService.getAllRecipes(0, Integer.MAX_VALUE)).thenReturn(List.of(RECIPE_A, RECIPE_B));

        assertThat(recipeController.getAllRecipes(0, Integer.MAX_VALUE).getBody()).isEqualTo(List.of(RECIPE_A, RECIPE_B));
    }

//    @SneakyThrows
//    @Test
//    void getRecipesByName_test() {
//        Mockito.when(recipeService.getRecipesByName("recipe")).thenReturn(List.of(RECIPE_A, RECIPE_B));
//
//        assertThat(recipeController.getRecipesByName("recipe").getBody()).isEqualTo(List.of(RECIPE_A, RECIPE_B));
//    }

    @SneakyThrows
    @Test
    void createRecipe_test() {
        Mockito.when(recipeService.addRecipe(NEW_RECIPE_REQUEST_A)).thenReturn(RECIPE_A);

        assertThat(recipeController.createRecipe(NEW_RECIPE_REQUEST_A).getBody()).isEqualTo(new MessageResponse("Successful save of new recipe: Recipe A"));
    }

    @SneakyThrows
    @Test
    void updateRecipe_test() {
        Mockito.when(recipeService.getRecipeById("1")).thenReturn(RECIPE_A);
        Mockito.when(recipeService.updateRecipe(RECIPE_A, UPDATE_RECIPE_REQUEST_A)).thenReturn(RECIPE_A);

        assertThat(recipeController.updateRecipe(UPDATE_RECIPE_REQUEST_A).getBody()).isEqualTo(new MessageResponse("Successful update of recipe: 1"));
    }

    @SneakyThrows
    @Test
    void deleteRecipe_test() {
        Mockito.when(recipeService.getRecipeById("1")).thenReturn(RECIPE_A);

        assertThat(recipeController.deleteRecipe("1", "1").getBody()).isEqualTo(new MessageResponse("Successful delete of recipe: 1"));
    }
}
