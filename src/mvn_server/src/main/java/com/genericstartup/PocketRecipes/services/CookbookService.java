package com.genericstartup.PocketRecipes.services;

import com.genericstartup.PocketRecipes.models.CookbookModel;
import com.genericstartup.PocketRecipes.repository.CookbookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CookbookService {

    @Autowired
    private CookbookRepository cookbookRepository;

    public List<CookbookModel> getAllCookbooks() {
        List<CookbookModel> cookbookModels = cookbookRepository.findAll(Sort.by(Sort.Direction.DESC, "name"));

        if (!cookbookModels.isEmpty()) {
            return cookbookModels;
        } else {
            return new ArrayList<>();
        }
    }

    public List<CookbookModel> searchCookbooksByName(String name) {
        List<CookbookModel> cookbookModels = cookbookRepository.findCookbookByNameContainingIgnoreCase(name);

        if (!cookbookModels.isEmpty()) {
            return cookbookModels;
        } else {
            return new ArrayList<>();
        }
    }

    public CookbookModel getCookbookById(String cookbookId) throws ChangeSetPersister.NotFoundException {
        return cookbookRepository.findById(cookbookId).orElseThrow(ChangeSetPersister.NotFoundException::new);
    }

    public CookbookModel saveCookbook(CookbookModel cookbookModel) {
        return cookbookRepository.save(cookbookModel);
    }

    public void deleteCookbook(CookbookModel cookbookModel) {
        cookbookRepository.delete(cookbookModel);
    }

    public List<CookbookModel> getUserOwnedCookbooks(String authorUserId) {
        return cookbookRepository.findByAuthorUserId(authorUserId);
    }

    public void removeRecipeFromAll(String recipeId) {
        for (CookbookModel cookbookModel : cookbookRepository.findAll()) {
            if (cookbookModel.getRecipeIdList() != null && cookbookModel.getRecipeIdList().contains(recipeId)) {
                cookbookModel.getRecipeIdList().remove(recipeId);
                cookbookRepository.save(cookbookModel);
            }
        }
    }
}
