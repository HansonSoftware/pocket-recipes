package com.genericstartup.PocketRecipes.controllers;

import com.genericstartup.PocketRecipes.models.AuthenticationRequest;
import com.genericstartup.PocketRecipes.models.UserModel;
import com.genericstartup.PocketRecipes.responses.MessageResponse;
import com.genericstartup.PocketRecipes.services.UserService;
import lombok.SneakyThrows;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class AuthenticationControllerTest {

    @Mock
    UserService userService;

    @InjectMocks
    AuthController authController;

    private static final UserDetails USER_DETAILS = new User("user", "pass", List.of());
    private static final AuthenticationRequest AUTHENTICATION_REQUEST = new AuthenticationRequest("user", "pass");

    @SneakyThrows
    @Test
    void subscribeClient_test() {
        Mockito.when(userService.loadUserByUsername("user")).thenReturn(null);

        assertThat(authController.subscribeClient(AUTHENTICATION_REQUEST).getBody()).isEqualTo(new MessageResponse("Successful Subscription for client user"));
    }

    @SneakyThrows
    @Test
    void authenticateClient_test() {
        assertThat(authController.authenticateClient(AUTHENTICATION_REQUEST).getBody()).isEqualTo(new MessageResponse("Error during client authentication user"));
    }
}
