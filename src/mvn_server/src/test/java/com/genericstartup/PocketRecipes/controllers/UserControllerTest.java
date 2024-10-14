package com.genericstartup.PocketRecipes.controllers;

import com.genericstartup.PocketRecipes.models.UserModel;
import com.genericstartup.PocketRecipes.responses.UsernameResponse;
import com.genericstartup.PocketRecipes.services.UserService;
import lombok.SneakyThrows;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
public class UserControllerTest {

    @Mock
    UserService userService;

    @InjectMocks
    UserController userController;

    private static final UserModel USER_A = new UserModel("1", "user1", "pass1", new ArrayList<>());

    @SneakyThrows
    @Test
    void getUsernameFromUserId_test() {
        Mockito.when(userService.getUsernameFromUserId("1")).thenReturn(USER_A.getUsername());

        assertThat(((UsernameResponse) userController.getAuthenticatedUsername("1").getBody()).getUsername())
                .isEqualTo("user1");
    }

    @SneakyThrows
    @Test
    void getUsernameFromUserId_not_found_test() {
        assertThat(((UsernameResponse) userController.getAuthenticatedUsername("invalid_id").getBody()).getUsername())
                .isNull();
    }

    @SneakyThrows
    @Test
    void getUserFromUserId_test() {
        Mockito.when(userService.getUserFromUserId("1")).thenReturn(USER_A);

        assertThat(((UserModel) userController.getAuthenticatedUser("1").getBody()))
                .isEqualTo(USER_A);
    }

    @SneakyThrows
    @Test
    void getUserFromUserId_not_found_test() {
        assertThat(((UserModel) userController.getAuthenticatedUser("invalid_id").getBody()))
                .isNull();
    }


//    @SneakyThrows
//    @Test
//    void getAuthenticatedUsername_test() {
//        Mockito.when(userService.getUsernameFromUserId("1")).thenReturn(USER_A.getUsername());
//
//        mockMvc.perform(get("/api/get-authenticated-username/{id}", "1"))
//            .andExpect(status().isOk())
//            .andExpect(content().contentType(MediaType.APPLICATION_JSON_VALUE))
//            .andExpect(jsonPath("$", hasSize(1)))
//            .andExpect(jsonPath("$[0].username", is("user1")));
//        verifyNoMoreInteractions(userService);
//    }
}
