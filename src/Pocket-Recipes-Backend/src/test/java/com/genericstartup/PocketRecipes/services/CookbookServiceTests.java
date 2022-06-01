package com.genericstartup.PocketRecipes.services;

import com.genericstartup.PocketRecipes.models.CookbookModel;
import com.genericstartup.PocketRecipes.repository.CookbookRepository;
import lombok.SneakyThrows;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Sort;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@SpringBootTest(classes = CookbookServiceTests.class)
public class CookbookServiceTests {

    @Mock
    CookbookRepository cookbookRepository;

    @InjectMocks
    CookbookService cookbookService;

    private static final CookbookModel COOKBOOK_A = new CookbookModel(null, "Cookbook A", "1", new ArrayList<>(Arrays.asList("1", "2")), "image");
    private static final CookbookModel COOKBOOK_B = new CookbookModel(null, "Cookbook B", "1", new ArrayList<>(Arrays.asList("3", "4")), "image2");

    @SneakyThrows
    @Test
    void getAllCookbooks_full_test() {
        Mockito.when(cookbookRepository.findAll(Sort.by(Sort.Direction.DESC, "name"))).thenReturn(List.of(COOKBOOK_A, COOKBOOK_B));

        List<CookbookModel> cookbookModelList = cookbookService.getAllCookbooks();

        assertThat(cookbookModelList).isEqualTo(List.of(COOKBOOK_A, COOKBOOK_B));
    }

    @SneakyThrows
    @Test
    void getAllCookbooks_empty_test() {
        Mockito.when(cookbookRepository.findAll()).thenReturn(List.of());

        List<CookbookModel> cookbookModelList = cookbookService.getAllCookbooks();

        assertThat(cookbookModelList).isEqualTo(List.of());
    }

    @SneakyThrows
    @Test
    void searchCookbooksByName_full_test() {
        Mockito.when(cookbookRepository.findCookbookByNameContainingIgnoreCase("cookbook")).thenReturn(List.of(COOKBOOK_A, COOKBOOK_B));

        List<CookbookModel> cookbookModelList = cookbookService.searchCookbooksByName("cookbook");

        assertThat(cookbookModelList).isEqualTo(List.of(COOKBOOK_A, COOKBOOK_B));
    }

    @SneakyThrows
    @Test
    void searchCookbooksByName_empty_test() {
        Mockito.when(cookbookRepository.findCookbookByNameContainingIgnoreCase("non-existent-name")).thenReturn(List.of());

        List<CookbookModel> cookbookModelList = cookbookService.searchCookbooksByName("non-existent-name");

        assertThat(cookbookModelList).isEqualTo(List.of());
    }

    @SneakyThrows
    @Test
    void getCookbookById_test() {
        Mockito.when(cookbookRepository.findById("1")).thenReturn(Optional.of(COOKBOOK_A));

        CookbookModel cookbookModel = cookbookService.getCookbookById("1");

        assertThat(cookbookModel).isSameAs(COOKBOOK_A);
    }

    @SneakyThrows
    @Test
    void saveCookbook_test() {
        Mockito.when(cookbookRepository.save(COOKBOOK_A)).thenReturn(COOKBOOK_A);

        CookbookModel cookbookModel = cookbookService.saveCookbook(COOKBOOK_A);

        assertThat(cookbookModel).isSameAs(COOKBOOK_A);
    }

    @SneakyThrows
    @Test
    void deleteCookbook_test() {
        cookbookService.deleteCookbook(COOKBOOK_A);
    }
}
