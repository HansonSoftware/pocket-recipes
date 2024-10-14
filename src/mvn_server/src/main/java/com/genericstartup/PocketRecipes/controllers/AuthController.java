package com.genericstartup.PocketRecipes.controllers;

import com.genericstartup.PocketRecipes.models.AuthenticationRequest;
import com.genericstartup.PocketRecipes.responses.AuthenticationResponse;
import com.genericstartup.PocketRecipes.responses.MessageResponse;
import com.genericstartup.PocketRecipes.models.UserModel;
import com.genericstartup.PocketRecipes.repository.UserRepository;
import com.genericstartup.PocketRecipes.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private AuthenticationManager authenticationManager;

    @PostMapping("/subs")
    ResponseEntity<?> subscribeClient(@RequestBody AuthenticationRequest authenticationRequest) {
        String username = authenticationRequest.getUsername();
        String password = authenticationRequest.getPassword();
        UserModel userModel = new UserModel();
        userModel.setUsername(username);
        userModel.setPassword(password);
        try {
            if (userService.loadUserByUsername(username) != null) {
                return ResponseEntity.ok(new MessageResponse("Username already exists in the system. Please pick a unique username."));
            } else {
                userRepository.save(userModel);
            }
            return ResponseEntity.ok(new MessageResponse("Successful Subscription for client " + username));
        } catch (Throwable t) {
            return ResponseEntity.ok(new MessageResponse("Error during client Subscription " + username));
        }
    }

    @PostMapping("/auth")
    ResponseEntity<?> authenticateClient(@RequestBody AuthenticationRequest authenticationRequest) {
        String username = authenticationRequest.getUsername();
        String password = authenticationRequest.getPassword();

        try {
            Authentication auth = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(username, password));
            SecurityContextHolder.getContext().setAuthentication(auth);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(new MessageResponse("Error during client authentication " + username));
        }

        return ResponseEntity.ok(new AuthenticationResponse(userRepository.findByUsername(username).getId(), new MessageResponse("Successful authentication for client " + username)));
    }

}
