package com.genericstartup.PocketRecipes.controllers;

import com.genericstartup.PocketRecipes.models.CookbookModel;
import com.genericstartup.PocketRecipes.responses.MessageResponse;
import com.genericstartup.PocketRecipes.models.RecipeModel;
import com.genericstartup.PocketRecipes.requests.CookbookRequest;
import com.genericstartup.PocketRecipes.requests.RecipeRequestBody;
import com.genericstartup.PocketRecipes.services.CookbookService;
import com.genericstartup.PocketRecipes.services.RecipeService;
import com.genericstartup.PocketRecipes.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
public class CookbookController {

    @Autowired
    private CookbookService cookbookService;

    @Autowired
    private RecipeService recipeService;

    @Autowired
    private UserService userService;

    @GetMapping("/public/get-all-cookbooks")
    ResponseEntity<List<CookbookModel>> getAllCookbooks() {
        try {
            return ResponseEntity.ok(cookbookService.getAllCookbooks());
        } catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/public/get-cookbooks-by-name/{name}")
    ResponseEntity<List<CookbookModel>> getCookbookByName(@PathVariable("name") String name) {
        try {
            return ResponseEntity.ok(cookbookService.searchCookbooksByName(name));
        } catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/public/get-cookbook-by-id/{cookbookId}")
    ResponseEntity<CookbookModel> getCookbookById(@PathVariable("cookbookId") String cookbookId) {
        try {
            return ResponseEntity.ok(cookbookService.getCookbookById(cookbookId));
        } catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("get-cookbooks-by-user/{userId}")
    ResponseEntity<List<CookbookModel>> getCookbookByUser(@PathVariable("userId") String userId) {
        try {
            return ResponseEntity.ok(cookbookService.getUserOwnedCookbooks(userId));
        } catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/public/get-recipes-by-cookbook-id/{cookbookId}")
    ResponseEntity<List<RecipeModel>> getRecipesByCookbookId(@PathVariable("cookbookId") String cookbookId) {
        try {

            List<RecipeModel> recipes = new ArrayList<>();
            for (String recipeId : cookbookService.getCookbookById(cookbookId).getRecipeIdList()) {
                recipes.add(recipeService.getRecipeById(recipeId));
            }

            if (recipes.isEmpty()) {
                return ResponseEntity.ok().build();
            }
            return ResponseEntity.ok(recipes);

        } catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/add-recipe-to-cookbook")
    ResponseEntity<?> addRecipeToCookbook(@RequestBody RecipeRequestBody recipeRequestBody) {
        try {
            CookbookModel cookbook = cookbookService.getCookbookById(recipeRequestBody.getCookbookId());

            if (userService.getUsernameFromUserId(recipeRequestBody.getUserId()).equals(userService.getUserFromUserId(cookbook.getAuthorUserId()).getUsername())) {
                if (cookbook.getRecipeIdList() == null) {
                    cookbook.setRecipeIdList(new ArrayList<>());
                }
                cookbook.getRecipeIdList().add(recipeRequestBody.getRecipeId());
                cookbookService.saveCookbook(cookbook);
                return ResponseEntity.ok(new MessageResponse("Cookbook: " + cookbook.getId() + " saved successfully"));
            }
            else {
                return ResponseEntity.badRequest().body(new MessageResponse("The authenticated user does not own this cookbook"));
            }
        } catch (ChangeSetPersister.NotFoundException e) {
            return ResponseEntity.notFound().build();
        }
        catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/remove-recipe-from-cookbook")
    ResponseEntity<?> removeRecipeFromCookbook(@RequestBody RecipeRequestBody recipeRequestBody) {
        try {
            CookbookModel cookbook = cookbookService.getCookbookById(recipeRequestBody.getCookbookId());

            if (userService.getUsernameFromUserId(recipeRequestBody.getUserId()).equals(userService.getUserFromUserId(cookbook.getAuthorUserId()).getUsername())) {
                cookbook.getRecipeIdList().remove(recipeRequestBody.getRecipeId());
                cookbookService.saveCookbook(cookbook);
                return ResponseEntity.ok(new MessageResponse("Cookbook: " + cookbook.getId() + " saved successfully"));
            }
            else {
                return ResponseEntity.badRequest().body(new MessageResponse("The authenticated user does not own this cookbook"));
            }
        }
        catch (ChangeSetPersister.NotFoundException e) {
            return ResponseEntity.notFound().build();
        }
        catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/create-new-cookbook")
    ResponseEntity<?> createNewCookbook(@RequestBody CookbookRequest cookbookRequest) {
        try {

            CookbookModel cookbookModel = new CookbookModel(null, cookbookRequest.getName(), cookbookRequest.getUserId(), new ArrayList<String>(), cookbookRequest.getImageURL());
            cookbookService.saveCookbook(cookbookModel);

            return ResponseEntity.ok(new MessageResponse("New cookbook added successfully"));
        }
        catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/remove-cookbook/{userId}/{cookbookId}")
    ResponseEntity<?> removeCookbook(@PathVariable("userId") String userId, @PathVariable("cookbookId") String cookbookId) {
        try {
            CookbookModel cookbook = cookbookService.getCookbookById(cookbookId);

            if (userService.getUsernameFromUserId(userId).equals(userService.getUserFromUserId(cookbook.getAuthorUserId()).getUsername())) {
                cookbookService.deleteCookbook(cookbook);
                return ResponseEntity.ok(new MessageResponse("Cookbook " + cookbookId + " deleted successfully"));
            }
            else {
                return ResponseEntity.badRequest().body(new MessageResponse("The authenticated user does not own this cookbook"));
            }
        } catch (ChangeSetPersister.NotFoundException e) {
            return ResponseEntity.notFound().build();
        }
        catch (Throwable t) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
