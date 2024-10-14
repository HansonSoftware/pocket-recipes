package com.genericstartup.PocketRecipes.services;

import com.genericstartup.PocketRecipes.exceptions.RecipeAlreadyExistsException;
import com.genericstartup.PocketRecipes.exceptions.RecipeDoesNotExistException;
import com.genericstartup.PocketRecipes.models.UserModel;
import com.genericstartup.PocketRecipes.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.crossstore.ChangeSetPersister;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserModel foundUser = userRepository.findByUsername(username);
        if (foundUser == null) {
            return null;
        }

        String name = foundUser.getUsername();
        String pwd = foundUser.getPassword();

        List<GrantedAuthority> authorityList = new ArrayList<>();
        return new User(name, pwd, authorityList);
    }

    public String getUsernameFromUserId(String userId) throws ChangeSetPersister.NotFoundException {
        return getUserFromUserId(userId).getUsername();
    }

    public UserModel getUserFromUserId(String userId) throws ChangeSetPersister.NotFoundException {
        return userRepository.findById(userId).orElseThrow(ChangeSetPersister.NotFoundException::new);
    }

    public List<String> addRecipeToUserFavorites(UserModel userModel, String newRecipeId) throws ChangeSetPersister.NotFoundException, RecipeAlreadyExistsException {
        if (userModel.getFavoriteRecipeIds() == null) {
            userModel.setFavoriteRecipeIds(new ArrayList<>());
        }

        if (userModel.getFavoriteRecipeIds().contains(newRecipeId)) {
            throw new RecipeAlreadyExistsException(newRecipeId);
        }

        userModel.getFavoriteRecipeIds().add(newRecipeId);

        userRepository.save(userModel);

        return userModel.getFavoriteRecipeIds();
    }

    public String removeRecipeToUserFavorites(UserModel userModel, String recipeId) throws RecipeDoesNotExistException {
        if (userModel.getFavoriteRecipeIds() == null) {
            throw new RecipeDoesNotExistException(recipeId);
        }

        if (userModel.getFavoriteRecipeIds().contains(recipeId)) {
            userModel.getFavoriteRecipeIds().remove(recipeId);
        } else {
            throw new RecipeDoesNotExistException(recipeId);
        }

        userRepository.save(userModel);

        return recipeId;
    }

    public void removeRecipeFromAll(String recipeId) {
        for (UserModel userModel : userRepository.findAll()) {
            if (userModel.getFavoriteRecipeIds() != null && userModel.getFavoriteRecipeIds().contains(recipeId)) {
                userModel.getFavoriteRecipeIds().remove(recipeId);
                userRepository.save(userModel);
            }
        }
    }
}
