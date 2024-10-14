package com.genericstartup.PocketRecipes;

import com.genericstartup.PocketRecipes.controllers.CookbookController;
import com.genericstartup.PocketRecipes.controllers.CookbookControllerTest;
import com.genericstartup.PocketRecipes.controllers.RecipeControllerTest;
import com.genericstartup.PocketRecipes.controllers.UserControllerTest;
import com.genericstartup.PocketRecipes.services.RecipeServiceTests;
import org.junit.internal.TextListener;
import org.junit.jupiter.api.Test;
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class PocketRecipesApplicationSystemTests {

	@Test
	void contextLoads() {
	}

//	@Test
//	void systemTests() {
//		JUnitCore jUnitCore = new JUnitCore();
//		jUnitCore.addListener(new TextListener(System.out));
//
//		Result result = jUnitCore.run(RecipeControllerTest.class, CookbookControllerTest.class, UserControllerTest.class);
//		resultReport(result);
//	}

	static void resultReport(Result result) {
		System.out.println("Finished. Result: Failures: " +
				result.getFailureCount() + ". Ignored: " +
				result.getIgnoreCount() + ". Tests run: " +
				result.getRunCount() + ". Time: " +
				result.getRunTime() + "ms.");
	}

}
