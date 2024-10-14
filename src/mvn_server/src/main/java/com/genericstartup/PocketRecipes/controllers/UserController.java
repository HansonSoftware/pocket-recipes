package com.genericstartup.PocketRecipes.controllers;

import com.genericstartup.PocketRecipes.models.CookbookModel;
import com.genericstartup.PocketRecipes.models.RecipeModel;
import com.genericstartup.PocketRecipes.models.UserModel;
import com.genericstartup.PocketRecipes.repository.UserRepository;
import com.genericstartup.PocketRecipes.responses.UserResponse;
import com.genericstartup.PocketRecipes.responses.UsernameResponse;
import com.genericstartup.PocketRecipes.services.CookbookService;
import com.genericstartup.PocketRecipes.services.RecipeService;
import com.genericstartup.PocketRecipes.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private RecipeService recipeService;

    @Autowired
    private CookbookService cookbookService;

    @GetMapping("/get-authenticated-username/{id}")
    ResponseEntity<?> getAuthenticatedUsername(@PathVariable("id") String userId) {
        try {
            return ResponseEntity.ok(new UsernameResponse(userService.getUsernameFromUserId(userId)));
        } catch (ChangeSetPersister.NotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/get-authenticated-user/{id}")
    ResponseEntity<?> getAuthenticatedUser(@PathVariable("id") String userId) {
        try {
            UserModel userModel = userService.getUserFromUserId(userId);
            List<RecipeModel> userOwnedRecipes = recipeService.getUserOwnedRecipes(userId);
            List<CookbookModel> userOwnedCookbooks = cookbookService.getUserOwnedCookbooks(userId);

            return ResponseEntity.ok(new UserResponse(userModel, userOwnedRecipes, userOwnedCookbooks));
        } catch (ChangeSetPersister.NotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
