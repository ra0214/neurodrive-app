allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    if (project.path != ":app") {
        project.evaluationDependsOn(":app")
    }

    // Configuración de Java 17
    tasks.withType<org.gradle.api.tasks.compile.JavaCompile>().configureEach {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }

    // Configuración moderna de Kotlin
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    // Fix de Namespace sin usar afterEvaluate
    // Se ejecuta inmediatamente si el plugin ya está aplicado
    val fixNamespace = {
        val android = project.extensions.findByName("android")
        if (android is com.android.build.gradle.BaseExtension) {
            if (android.namespace == null) {
                android.namespace = project.group.toString()
            }
        }
    }

    plugins.withId("com.android.application") { fixNamespace() }
    plugins.withId("com.android.library") { fixNamespace() }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
