package com.genericstartup.PocketRecipes.controllers;

import com.genericstartup.PocketRecipes.exceptions.RecipeAlreadyExistsException;
import com.genericstartup.PocketRecipes.exceptions.RecipeDoesNotExistException;
import com.genericstartup.PocketRecipes.models.RecipeModel;
import com.genericstartup.PocketRecipes.models.UserModel;
import com.genericstartup.PocketRecipes.requests.NewRecipeRequest;
import com.genericstartup.PocketRecipes.requests.UpdateRecipeRequest;
import com.genericstartup.PocketRecipes.responses.MessageResponse;
import com.genericstartup.PocketRecipes.services.RecipeService;
import com.genericstartup.PocketRecipes.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class RecipeController {

    @Autowired
    private RecipeService recipeService;

    @Autowired
    private UserService userService;

    @GetMapping("/public/get-all-recipes/{pageNumber}/{pageSize}")
    ResponseEntity<List<RecipeModel>> getAllRecipes(@PathVariable("pageNumber") int pageNumber, @PathVariable("pageSize") int pageSize) {
        try {
            return ResponseEntity.ok(recipeService.getAllRecipes(pageNumber, pageSize));
        } catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/public/get-recipe-by-id/{recipeId}")
    ResponseEntity<?> favoriteRecipe(@PathVariable("recipeId") String recipeId) {
        try {
            return ResponseEntity.ok(recipeService.getRecipeById(recipeId));
        } catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/public/get-recipes-by-name/{name}/{pageNumber}/{pageSize}")
    ResponseEntity<List<RecipeModel>> getRecipesByName(@PathVariable("name") String name, @PathVariable("pageNumber") int pageNumber, @PathVariable("pageSize") int pageSize) {
        try {
            return ResponseEntity.ok(recipeService.getRecipesByName(name, pageNumber, pageSize));
        } catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/favorite-recipe/{userId}/{recipeId}")
    ResponseEntity<?> favoriteRecipe(@PathVariable("userId") String userId, @PathVariable("recipeId") String recipeId) {
        try {
            UserModel userModel = userService.getUserFromUserId(userId);
            if (userModel != null) {
                userService.addRecipeToUserFavorites(userModel, recipeService.getRecipeById(recipeId).getId());
                recipeService.favoriteRecipe(recipeId);
                return ResponseEntity.ok(new MessageResponse("Recipe: " + recipeId + " favorited successfully by user: " + userId));
            } else {
                throw new ChangeSetPersister.NotFoundException();
            }
        }
        catch (ChangeSetPersister.NotFoundException e) {
            return ResponseEntity.notFound().build();
        }
        catch (RecipeAlreadyExistsException e1) {
            return ResponseEntity.internalServerError().body(new MessageResponse("Recipe: " + recipeId + " already favorited by user: " + userId));
        }
        catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/unfavorite-recipe/{userId}/{recipeId}")
    ResponseEntity<?> unfavoriteRecipe(@PathVariable("userId") String userId, @PathVariable("recipeId") String recipeId) {
        try {
            UserModel userModel = userService.getUserFromUserId(userId);
            if (userModel != null) {
                userService.removeRecipeToUserFavorites(userModel, recipeService.getRecipeById(recipeId).getId());
                recipeService.unfavoriteRecipe(recipeId);
                return ResponseEntity.ok(new MessageResponse("Recipe: " + recipeId + " unfavorited successfully by user: " + userId));
            } else {
                throw new ChangeSetPersister.NotFoundException();
            }
        }
        catch (ChangeSetPersister.NotFoundException e) {
            return ResponseEntity.notFound().build();
        }
        catch (RecipeDoesNotExistException e1) {
            return ResponseEntity.internalServerError().body(new MessageResponse("Recipe: " + recipeId + " not already favorited by user: " + userId));
        }
        catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/create-recipe")
    ResponseEntity<?> createRecipe(@RequestBody NewRecipeRequest newRecipeRequest) {
        try {
            recipeService.addRecipe(newRecipeRequest);
            return ResponseEntity.ok(new MessageResponse("Successful save of new recipe: " + newRecipeRequest.getName()));
        } catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/update-recipe")
    ResponseEntity<?> updateRecipe(@RequestBody UpdateRecipeRequest updateRecipeRequest) {
        try {
            RecipeModel recipeModel = recipeService.getRecipeById(updateRecipeRequest.getRecipeId());
            if (updateRecipeRequest.getUserId().equals(recipeModel.getAuthorUserId())) {
                String updatedRecipeId = recipeService.updateRecipe(recipeModel, updateRecipeRequest).getId();
                return ResponseEntity.ok(new MessageResponse("Successful update of recipe: " + updatedRecipeId));
            }
            else {
                return ResponseEntity.badRequest().body(new MessageResponse("The authenticated user does not own this recipe"));
            }

        }
        catch (ChangeSetPersister.NotFoundException e) {
            return ResponseEntity.notFound().build();
        }
        catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/delete-recipe/{userId}/{recipeId}")
    ResponseEntity<?> deleteRecipe(@PathVariable("userId") String userId, @PathVariable("recipeId") String recipeId) {
        try {
            RecipeModel recipeModel = recipeService.getRecipeById(recipeId);

            if (userId.equals(recipeModel.getAuthorUserId())) {
                recipeService.deleteRecipe(recipeModel.getId());
                return ResponseEntity.ok(new MessageResponse("Successful delete of recipe: " + recipeModel.getId()));
            }
            else {
                return ResponseEntity.badRequest().body(new MessageResponse("The authenticated user does not own this recipe"));
            }

        }
        catch (ChangeSetPersister.NotFoundException e) {
            return ResponseEntity.notFound().build();
        }
        catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
