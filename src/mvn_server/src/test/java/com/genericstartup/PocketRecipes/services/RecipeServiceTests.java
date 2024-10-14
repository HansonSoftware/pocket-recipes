package com.genericstartup.PocketRecipes.services;

import com.genericstartup.PocketRecipes.models.RecipeModel;
import com.genericstartup.PocketRecipes.repository.RecipeRepository;
import com.genericstartup.PocketRecipes.requests.NewRecipeRequest;
import com.genericstartup.PocketRecipes.requests.UpdateRecipeRequest;
import lombok.SneakyThrows;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Sort;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(classes = RecipeServiceTests.class)
public class RecipeServiceTests {

    @Mock
    RecipeRepository recipeRepository;

    @InjectMocks
    RecipeService recipeService;

    private static final RecipeModel RECIPE_A = new RecipeModel(null, "1", List.of("author1", "author2"), "Recipe A", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"), 0);
    private static final RecipeModel RECIPE_B = new RecipeModel(null, "1", List.of("author1", "author2"), "Recipe B", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"), 0);

    private static final NewRecipeRequest NEW_RECIPE_REQUEST_A = new NewRecipeRequest("1", List.of("author1", "author2"), "Recipe A", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"));
    private static final UpdateRecipeRequest UPDATE_RECIPE_REQUEST_A = new UpdateRecipeRequest("1", null, List.of("author1", "author2"), "Recipe A", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"));

    @SneakyThrows
    @Test
    void getRecipeById_test() {
        Mockito.when(recipeRepository.findById("1")).thenReturn(Optional.of(RECIPE_A));

        RecipeModel recipeModel = recipeService.getRecipeById("1");

        assertThat(recipeModel).isSameAs(RECIPE_A);
    }

//    @SneakyThrows
//    @Test
//    void getAllRecipes_full_test() {
//        Mockito.when(recipeRepository.findAll(Sort.by(Sort.Direction.DESC, "name"))).thenReturn(List.of(RECIPE_A, RECIPE_B));
//
//        List<RecipeModel> recipeModelList = recipeService.getAllRecipes(0, Integer.MAX_VALUE);
//
//        assertThat(recipeModelList).isEqualTo(List.of(RECIPE_A, RECIPE_B));
//    }
//
//    @SneakyThrows
//    @Test
//    void getAllRecipes_empty_test() {
//        List<RecipeModel> recipeModelList = recipeService.getAllRecipes(0, Integer.MAX_VALUE);
//
//        assertThat(recipeModelList).isEqualTo(List.of());
//    }

//    @SneakyThrows
//    @Test
//    void getRecipesByName_full_test() {
//        Mockito.when(recipeRepository.findRecipeByNameContainingIgnoreCase("recipe")).thenReturn(List.of(RECIPE_A, RECIPE_B));
//
//        List<RecipeModel> recipeModelList = recipeService.getRecipesByName("recipe");
//
//        assertThat(recipeModelList).isEqualTo(List.of(RECIPE_A, RECIPE_B));
//    }
//
//    @SneakyThrows
//    @Test
//    void getRecipesByName_empty_test() {
//        Mockito.when(recipeRepository.findRecipeByNameContainingIgnoreCase("empty")).thenReturn(List.of());
//
//        List<RecipeModel> recipeModelList = recipeService.getRecipesByName("empty");
//
//        assertThat(recipeModelList).isEqualTo(List.of());
//    }

    @SneakyThrows
    @Test
    void addRecipe_test() {
        Mockito.when(recipeRepository.save(RECIPE_A)).thenReturn(RECIPE_A);

        RecipeModel recipeModel = recipeService.addRecipe(NEW_RECIPE_REQUEST_A);

        assertThat(recipeModel).isSameAs(RECIPE_A);
    }

    @SneakyThrows
    @Test
    void updateRecipe_test() {
        Mockito.when(recipeRepository.save(RECIPE_A)).thenReturn(RECIPE_A);

        RecipeModel recipeModel = recipeService.updateRecipe(RECIPE_A, UPDATE_RECIPE_REQUEST_A);

        assertThat(recipeModel).isSameAs(RECIPE_A);
    }

    @SneakyThrows
    @Test
    void deleteRecipe_test() {
        recipeService.deleteRecipe(RECIPE_A.getId());
    }

}
