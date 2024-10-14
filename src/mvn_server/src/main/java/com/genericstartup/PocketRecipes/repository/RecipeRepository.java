package com.genericstartup.PocketRecipes.repository;

import com.genericstartup.PocketRecipes.models.RecipeModel;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecipeRepository extends MongoRepository<RecipeModel, String> {

    RecipeModel findRecipeById(String id);

    List<RecipeModel> findRecipeByNameContainingIgnoreCase(String recipeName, Pageable pageable);

    List<RecipeModel> findByAuthorUserId(String authorUserId);
}
