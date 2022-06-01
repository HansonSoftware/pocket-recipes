package com.genericstartup.PocketRecipes.services;

import com.genericstartup.PocketRecipes.models.UserModel;
import com.genericstartup.PocketRecipes.repository.UserRepository;
import lombok.SneakyThrows;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(classes = UserServiceTests.class)
class UserServiceTests {

    @Mock
    UserRepository userRepository;

    @InjectMocks
    UserService userService;

    private final UserModel USER = new UserModel("1", "username", "password", new ArrayList<>());

    @BeforeEach
    public void init() {
        Mockito.when(userRepository.findById("1")).thenReturn(Optional.of(USER));
    }

    @SneakyThrows
    @Test
    void loadUserByUsername_test() {
        Mockito.when(userRepository.findByUsername("username")).thenReturn(USER);

        UserDetails user = userService.loadUserByUsername("username");

        assertThat(user).isEqualTo(new User("username", "password", List.of()));
    }

    @SneakyThrows
    @Test
    void loadUserByUsername_not_found_test() {
        UserDetails user = userService.loadUserByUsername("invalid_username");

        assertThat(user).isEqualTo(null);
    }

    @SneakyThrows
    @Test
    void getUsernameFromUserId_test() {
        String username = userService.getUsernameFromUserId("1");

        assertThat(username).isSameAs("username");
    }

    @SneakyThrows
    @Test
    void getUserFromUserId_test() {
        UserModel user = userService.getUserFromUserId("1");

        assertThat(user).isSameAs(USER);
    }
}
