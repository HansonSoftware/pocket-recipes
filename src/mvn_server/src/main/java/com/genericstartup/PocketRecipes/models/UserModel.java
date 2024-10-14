package com.genericstartup.PocketRecipes.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "users")
public class UserModel {

    @Id
    private String id;
    private String username;
    private String password;
    private ArrayList<String> favoriteRecipeIds;

}
