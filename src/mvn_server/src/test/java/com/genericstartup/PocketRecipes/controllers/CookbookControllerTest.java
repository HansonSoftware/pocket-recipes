package com.genericstartup.PocketRecipes.controllers;

import com.genericstartup.PocketRecipes.models.CookbookModel;
import com.genericstartup.PocketRecipes.models.RecipeModel;
import com.genericstartup.PocketRecipes.models.UserModel;
import com.genericstartup.PocketRecipes.requests.CookbookRequest;
import com.genericstartup.PocketRecipes.requests.RecipeRequestBody;
import com.genericstartup.PocketRecipes.responses.MessageResponse;
import com.genericstartup.PocketRecipes.services.CookbookService;
import com.genericstartup.PocketRecipes.services.RecipeService;
import com.genericstartup.PocketRecipes.services.UserService;
import lombok.SneakyThrows;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class CookbookControllerTest {

    @Mock
    CookbookService cookbookService;

    @Mock
    RecipeService recipeService;

    @Mock
    UserService userService;

    @InjectMocks
    CookbookController cookbookController;

    private static final CookbookModel COOKBOOK_A = new CookbookModel("1", "Cookbook A", "1", new ArrayList<>(Arrays.asList("1", "2")), "image");
    private static final CookbookModel COOKBOOK_B = new CookbookModel("2", "Cookbook B", "1", new ArrayList<>(Arrays.asList("3", "4")), "image2");

    private static final RecipeModel RECIPE_A = new RecipeModel("1", "1", List.of("author1", "author2"), "Recipe A", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"), 0);
    private static final RecipeModel RECIPE_B = new RecipeModel("2", "1", List.of("author1", "author2"), "Recipe B", "photo", List.of("step1", "step2"), List.of("Ingredient1", "Ingredient2"), List.of("IName1", "IName2"), 0);

    private static final CookbookRequest COOKBOOK_REQUEST_A = new CookbookRequest("1", "Cookbook A", "image");

    @SneakyThrows
    @Test
    public void getAllCookbooks_test() {
        Mockito.when(cookbookService.getAllCookbooks()).thenReturn(List.of(COOKBOOK_A, COOKBOOK_B));

        assertThat(cookbookController.getAllCookbooks().getBody()).isEqualTo(List.of(COOKBOOK_A, COOKBOOK_B));
    }

    @SneakyThrows
    @Test
    public void getCookbooksByName_test() {
        Mockito.when(cookbookService.searchCookbooksByName("cookbook")).thenReturn(List.of(COOKBOOK_A, COOKBOOK_B));

        assertThat(cookbookController.getCookbookByName("cookbook").getBody()).isEqualTo(List.of(COOKBOOK_A, COOKBOOK_B));
    }

    @SneakyThrows
    @Test
    public void getRecipesByCookbookId_test() {
        Mockito.when(cookbookService.getCookbookById("1")).thenReturn(COOKBOOK_A);
        Mockito.when(recipeService.getRecipeById("1")).thenReturn(RECIPE_A);
        Mockito.when(recipeService.getRecipeById("2")).thenReturn(RECIPE_B);

        assertThat(cookbookController.getRecipesByCookbookId("1").getBody()).isEqualTo(new ArrayList<>(List.of(RECIPE_A, RECIPE_B)));
    }

    @SneakyThrows
    @Test
    public void addRecipeToCookbook_test() {
        Mockito.when(cookbookService.getCookbookById("1")).thenReturn(COOKBOOK_A);
        Mockito.when(userService.getUsernameFromUserId("1")).thenReturn("user1");
        Mockito.when(userService.getUserFromUserId("1")).thenReturn(new UserModel("1", "user1", "pass1", new ArrayList<>()));
        Mockito.when(cookbookService.saveCookbook(COOKBOOK_A)).thenReturn(COOKBOOK_A);

        assertThat(cookbookController.addRecipeToCookbook(new RecipeRequestBody("1", "1", "1")).getBody()).isEqualTo(new MessageResponse("Cookbook: 1 saved successfully"));
    }

    @SneakyThrows
    @Test
    public void createNewCookbook_test() {
        Mockito.when(cookbookService.saveCookbook(COOKBOOK_A)).thenReturn(COOKBOOK_A);

        assertThat(cookbookController.createNewCookbook(COOKBOOK_REQUEST_A).getBody()).isEqualTo(new MessageResponse("New cookbook added successfully"));
    }

    @SneakyThrows
    @Test
    public void removeRecipeFromCookbook_test() {
        Mockito.when(cookbookService.getCookbookById("1")).thenReturn(COOKBOOK_A);
        Mockito.when(userService.getUsernameFromUserId("1")).thenReturn("user1");
        Mockito.when(userService.getUserFromUserId("1")).thenReturn(new UserModel("1", "user1", "pass1", new ArrayList<>()));
        Mockito.when(cookbookService.saveCookbook(COOKBOOK_A)).thenReturn(COOKBOOK_A);

        assertThat(cookbookController.removeRecipeFromCookbook(new RecipeRequestBody("1", "1", "1")).getBody()).isEqualTo(new MessageResponse("Cookbook: 1 saved successfully"));
    }

    @SneakyThrows
    @Test
    public void removeCookbook_test() {
        Mockito.when(cookbookService.getCookbookById("1")).thenReturn(COOKBOOK_A);
        Mockito.when(userService.getUsernameFromUserId("1")).thenReturn("user1");
        Mockito.when(userService.getUserFromUserId("1")).thenReturn(new UserModel("1", "user1", "pass1", new ArrayList<>()));
        Mockito.when(cookbookService.saveCookbook(COOKBOOK_A)).thenReturn(COOKBOOK_A);

        assertThat(cookbookController.removeCookbook("1", "1").getBody()).isEqualTo(new MessageResponse("Cookbook 1 deleted successfully"));
    }
}
