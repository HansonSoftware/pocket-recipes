package com.genericstartup.PocketRecipes.services;

import com.genericstartup.PocketRecipes.models.RecipeModel;
import com.genericstartup.PocketRecipes.repository.RecipeRepository;
import com.genericstartup.PocketRecipes.requests.NewRecipeRequest;
import com.genericstartup.PocketRecipes.requests.UpdateRecipeRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RecipeService {

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private CookbookService cookbookService;

    @Autowired
    private UserService userService;

    public RecipeModel getRecipeById(String recipeId) throws ChangeSetPersister.NotFoundException {
        return recipeRepository.findById(recipeId).orElseThrow(ChangeSetPersister.NotFoundException::new);
    }

    public List<RecipeModel> getAllRecipes(int pageNumber, int pageSize) {
        Pageable page = PageRequest.of(pageNumber, pageSize);
        Page<RecipeModel> pagedResult = recipeRepository.findAll(page);

        if (pagedResult.hasContent()) {
            return pagedResult.getContent();
        } else {
            return new ArrayList<>();
        }
    }

    public List<RecipeModel> getUserOwnedRecipes(String authorUserId) {
        return recipeRepository.findByAuthorUserId(authorUserId);
    }

    public List<RecipeModel> getRecipesByName(String name, int pageNumber, int pageSize) {
        List<RecipeModel> recipes = recipeRepository.findRecipeByNameContainingIgnoreCase(name, PageRequest.of(pageNumber, pageSize));

        if (!recipes.isEmpty()) {
            return recipes;
        } else {
            return new ArrayList<>();
        }
    }

    public RecipeModel addRecipe(NewRecipeRequest newRecipeRequest) {
        RecipeModel recipeModel = new RecipeModel(null, newRecipeRequest.getUserId(), newRecipeRequest.getAuthors(), newRecipeRequest.getName(), newRecipeRequest.getPhotoURL(), newRecipeRequest.getDirections(), newRecipeRequest.getIngredients(), newRecipeRequest.getIngredientNames(), 0);
        return recipeRepository.save(recipeModel);
    }

    public RecipeModel updateRecipe(RecipeModel recipeModel, UpdateRecipeRequest updateRecipeRequest) {
        recipeModel.setAuthors(updateRecipeRequest.getAuthors());
        recipeModel.setName(updateRecipeRequest.getName());
        recipeModel.setPhotoURL(updateRecipeRequest.getPhotoURL());
        recipeModel.setDirections(updateRecipeRequest.getDirections());
        recipeModel.setIngredients(updateRecipeRequest.getIngredients());
        recipeModel.setIngredientNames(updateRecipeRequest.getIngredientNames());

        return recipeRepository.save(recipeModel);
    }

    public void deleteRecipe(String recipeId) {
        recipeRepository.deleteById(recipeId);
        cookbookService.removeRecipeFromAll(recipeId);
        userService.removeRecipeFromAll(recipeId);
    }

    public void favoriteRecipe(String recipeId) throws ChangeSetPersister.NotFoundException {
        RecipeModel recipeModel = getRecipeById(recipeId);

        int recipeFavorites = recipeModel.getRecipeFavorites();
        recipeFavorites++;

        recipeModel.setRecipeFavorites(recipeFavorites);

        recipeRepository.save(recipeModel);
    }

    public void unfavoriteRecipe(String recipeId) throws ChangeSetPersister.NotFoundException {
        RecipeModel recipeModel = getRecipeById(recipeId);

        int recipeFavorites = recipeModel.getRecipeFavorites();
        recipeFavorites--;

        recipeModel.setRecipeFavorites(recipeFavorites);

        recipeRepository.save(recipeModel);
    }
}
