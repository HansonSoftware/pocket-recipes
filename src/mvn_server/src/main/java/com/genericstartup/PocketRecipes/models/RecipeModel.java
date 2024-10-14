package com.genericstartup.PocketRecipes.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Document(collection = "recipes")
public class RecipeModel {

    @Id
    private String id;
    private String authorUserId;
    private List<String> authors;
    private String name;
    private String photoURL;
    private List<String> directions;
    private List<String> ingredients;
    private List<String> ingredientNames;
    private int recipeFavorites;

}
