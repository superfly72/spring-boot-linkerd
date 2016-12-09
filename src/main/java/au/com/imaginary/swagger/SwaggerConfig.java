package au.com.imaginary.swagger;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import static springfox.documentation.builders.PathSelectors.regex;


@Configuration
@ConditionalOnExpression("${swagger.enabled}")
@EnableSwagger2
public class SwaggerConfig {

    @Value("${swagger.title}")
    private String title;

    @Value("${swagger.description}")
    private String description;

    @Bean
    public Docket newsApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .groupName("all")
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/*"))
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title(title)
                .description(description)
                .version("2.0")
                .build();
    }
}
