package com.genericstartup.PocketRecipes.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "cookbooks")
public class CookbookModel {

    @Id
    private String id;
    private String name;
    private String authorUserId;
    private ArrayList<String> recipeIdList;
    private String imageURL;

}
