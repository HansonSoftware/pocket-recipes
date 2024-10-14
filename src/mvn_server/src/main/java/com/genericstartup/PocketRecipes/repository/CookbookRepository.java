package com.genericstartup.PocketRecipes.repository;

import com.genericstartup.PocketRecipes.models.CookbookModel;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CookbookRepository extends MongoRepository<CookbookModel, String> {

    CookbookModel findCookbookById(String id);

    List<CookbookModel> findCookbookByNameContainingIgnoreCase(String name);

    List<CookbookModel> findByAuthorUserId(String authorUserId);
}
