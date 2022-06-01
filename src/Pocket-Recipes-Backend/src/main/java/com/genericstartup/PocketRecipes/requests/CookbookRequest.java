package com.genericstartup.PocketRecipes.requests;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CookbookRequest {
    private String userId;
    private String name;
    private String imageURL;
}
