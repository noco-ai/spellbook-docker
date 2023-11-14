-- MySQL dump 10.13  Distrib 5.7.32, for Linux (x86_64)
--
-- Host: localhost    Database: spellbook
-- ------------------------------------------------------
-- Server version	5.7.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `chat_ability`
--

DROP TABLE IF EXISTS `chat_ability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat_ability` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uses` json NOT NULL,
  `module` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_published` int(11) NOT NULL DEFAULT '0',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `author` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `published_version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `chat_conversation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat_conversation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `is_private` tinyint(1) NOT NULL,
  `is_shared` tinyint(1) NOT NULL,
  `system_message` text COLLATE utf8mb4_unicode_ci,
  `use_model` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `topic` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seed` int(10) DEFAULT '-1',
  `temperature` float DEFAULT '1',
  `top_k` float DEFAULT '0.9',
  `top_p` float DEFAULT '0.9',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `locked` int(10) unsigned DEFAULT '0',
  `router_config` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'function_calling,model_routing,pin_functions,pin_models',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2052 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `chat_conversation_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat_conversation_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `conversation_id` int(10) unsigned NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `active_child_id` int(10) unsigned DEFAULT NULL,
  `num_children` int(11) DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shortcuts` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `files` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7503 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dynamic_functions`
--

DROP TABLE IF EXISTS `dynamic_functions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dynamic_functions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `definition` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dynamic_functions`
--

LOCK TABLES `dynamic_functions` WRITE;
/*!40000 ALTER TABLE `dynamic_functions` DISABLE KEYS */;
INSERT INTO `dynamic_functions` VALUES (5,'{\n  \"function_description\": \"Calculates the product of two numbers.\",\n  \"parameters\": {\n    \"num1\": {\n      \"description\": \"The first number to be multiplied.\",\n      \"type\": \"number\"\n    },\n    \"num2\": {\n      \"description\": \"The second number to be multiplied.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { num1, num2 } = params;\n    const result = num1 * num2;\n    return `The product of ${num1} and ${num2} is ${result}.`;\n}','2023-10-23 21:52:47','2023-10-23 21:52:47'),(6,'{\n  \"function_description\": \"Calculates the square root of a given number.\",\n  \"parameters\": {\n    \"num\": {\n      \"description\": \"The number to calculate the square root of.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { num } = params;\n    const result = Math.sqrt(num);\n    return `The square root of ${num} is ${result}.`;\n}','2023-10-23 21:56:13','2023-10-23 21:56:13'),(7,'{\n  \"function_description\": \"This function counts the number of occurrences of a given word in a given text.\",\n  \"parameters\": {\n    \"word\": {\n      \"description\": \"The word to count the occurrences for.\",\n      \"type\": \"string\"\n    },\n    \"text\": {\n      \"description\": \"The text from which to count the occurrences.\",\n      \"type\": \"string\"\n    }\n  }\n}','function executeFunction(params) {\n    const { word, text } = params;\n    const count = (text.match(new RegExp(word, \"gi\")) || []).length;\n    return `The word \'${word}\' appears ${count} times in the given text.`;\n}','2023-10-23 22:29:42','2023-10-23 22:29:42'),(9,'{\n  \"function_description\": \"This function calculates the sum of two numbers.\",\n  \"parameters\": {\n    \"num1\": {\n      \"description\": \"The first number to be added.\",\n      \"type\": \"number\"\n    },\n    \"num2\": {\n      \"description\": \"The second number to be added.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { num1, num2 } = params;\n    const result = num1 + num2;\n    return `The sum of ${num1} and ${num2} is ${result}.`;\n}','2023-10-24 06:25:43','2023-10-24 06:25:43'),(12,'{\n  \"function_description\": \"Calculates the factorial of a given number.\",\n  \"parameters\": {\n    \"num\": {\n      \"description\": \"The number to calculate the factorial for.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { num } = params;\n    let result = 1;\n\n    for (let i = 2; i <= num; i++) {\n        result *= i;\n    }\n\n    return `The factorial of ${num} is ${result}.`;\n}','2023-10-24 21:23:30','2023-10-24 21:23:30'),(13,'{\n  \"function_description\": \"This function checks if a given word is a palindrome.\",\n  \"parameters\": {\n    \"word\": {\n      \"description\": \"The word to check for palindromicity.\",\n      \"type\": \"string\"\n    }\n  }\n}','function executeFunction(params) {\n    const { word } = params;\n    const isPalindrome = word.toLowerCase() === word.toLowerCase().split(\'\').reverse().join(\'\');\n    return isPalindrome ? `${word} is a palindrome.` : `${word} is not a palindrome.`;\n}','2023-10-24 21:24:39','2023-10-24 21:24:39'),(14,'{\n  \"function_description\": \"This function checks if a given number is a prime number or not.\",\n  \"parameters\": {\n    \"number\": {\n      \"description\": \"The number to be checked for primality.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { number } = params;\n    \n    let isPrime = true;\n\n    if (number === 1) {\n        isPrime = false;\n    } else if (number > 1) {\n        for (let i = 2; i < number; i++) {\n            if (number % i === 0) {\n                isPrime = false;\n                break;\n            }\n        }\n    }\n\n    return isPrime \n        ? `${number} is a prime number.` \n        : `${number} is not a prime number.`;\n}','2023-10-24 21:25:31','2023-10-24 21:25:31'),(15,'{\n  \"function_description\": \"This function calculates the greatest common divisor (GCD) of two numbers.\",\n  \"parameters\": {\n    \"num1\": {\n      \"description\": \"The first number to calculate GCD with.\",\n      \"type\": \"number\"\n    },\n    \"num2\": {\n      \"description\": \"The second number to calculate GCD with.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    let num1 = params.num1, num2 = params.num2;\n    while(num2) {\n        let t = num2;\n        num2 = num1 % num2;\n        num1 = t;\n    }\n    return `The greatest common divisor of ${params.num1} and ${params.num2} is ${num1}.`;\n}','2023-10-24 21:26:32','2023-10-24 21:26:32'),(16,'{\n  \"function_description\": \"This function calculates the least common multiple (LCM) of two numbers.\",\n  \"parameters\": {\n    \"num1\": {\n      \"description\": \"The first number to calculate LCM with.\",\n      \"type\": \"number\"\n    },\n    \"num2\": {\n      \"description\": \"The second number to calculate LCM with.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { num1, num2 } = params;\n    let lcm;\n    let max = Math.max(num1, num2);\n    let min = Math.min(num1, num2);\n    for (let i = max; ; i += max) {\n        if (i % min === 0) {\n            lcm = i;\n            break;\n        }\n    }\n    return `The least common multiple of ${num1} and ${num2} is ${lcm}.`;\n}','2023-10-24 21:27:00','2023-10-24 21:27:00'),(18,'{\n  \"function_description\": \"This function takes an array as input and returns a list of duplicate numbers.\",\n  \"parameters\": {\n    \"array\": {\n      \"description\": \"The array containing the elements to search for duplicates.\",\n      \"type\": \"list\"\n    }\n  }\n}','function executeFunction(params) {\n    const { array } = params;\n    let duplicates = [];\n    array.sort();\n    \n    for (let i = 0; i < array.length; i++) {\n        if (array[i + 1] === array[i]) {\n            duplicates.push(array[i]);\n        }\n    }\n    \n    duplicates = [...new Set(duplicates)];\n    return `The duplicate numbers in the given array are ${duplicates.join(\", \")}.`;\n}','2023-10-24 21:29:31','2023-10-24 21:29:31'),(20,'{\n  \"function_description\": \"This function takes an integer as input and returns its reverse.\",\n  \"parameters\": {\n    \"num\": {\n      \"description\": \"The number to be reversed.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { num } = params;\n    const reversed = parseInt(num.toString().split(\'\').reverse().join(\'\')) * Math.sign(num);\n    return `The reverse of ${num} is ${reversed}.`;\n}','2023-10-24 21:31:51','2023-10-24 21:31:51'),(21,'{\n  \"function_description\": \"This function takes a list of numbers as input and returns the third highest number.\",\n  \"parameters\": {\n    \"numbers\": {\n      \"description\": \"The list of numbers to find the third highest from.\",\n      \"type\": \"array\"\n    }\n  }\n}','function executeFunction(params) {\n    const { numbers } = params;\n    const sortedNumbers = numbers.sort((a, b) => b - a);\n    const thirdHighestNumber = sortedNumbers[2];\n    return `The third highest number in the list [${numbers}] is ${thirdHighestNumber}.`;\n}','2023-10-24 21:32:17','2023-10-24 21:32:17'),(22,'{\n  \"function_description\": \"This function finds all the prime numbers in a given range.\",\n  \"parameters\": {\n    \"start\": {\n      \"description\": \"The starting number of the range.\",\n      \"type\": \"number\"\n    },\n    \"end\": {\n      \"description\": \"The ending number of the range.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { start, end } = params;\n    let primes = [];\n    \n    for(let i = start; i <= end; i++) {\n        if(isPrime(i)) {\n            primes.push(i);\n        }\n    }\n\n    function isPrime(num) {\n        for(let i = 2, sqrt = Math.sqrt(num); i <= sqrt; i++)\n            if(num % i === 0) return false; \n        return num > 1;\n    }\n\n    return `The prime numbers between ${start} and ${end} are ${primes.join(\", \")}.`;\n}','2023-10-24 21:33:12','2023-10-24 21:33:12'),(24,'{\n  \"function_description\": \"This function calculates the voltage across a given resistor based on its resistance and current.\",\n  \"parameters\": {\n    \"resistance\": {\n      \"description\": \"The resistance value of the resistor in Ohms (Ω).\",\n      \"type\": \"number\"\n    },\n    \"current\": {\n      \"description\": \"The current flowing through the resistor in Amperes (A).\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { resistance, current } = params;\n    const voltage = resistance * current;\n    return `The voltage across a resistor with a resistance of ${resistance} Ohms and current of ${current} Amperes is ${voltage} Volts.`;\n}','2023-10-24 21:35:46','2023-10-24 21:35:46'),(25,'{\n  \"function_description\": \"This function calculates the amount of power dissipated in a resistive element given its resistance and current.\",\n  \"parameters\": {\n    \"resistance\": {\n      \"description\": \"The resistance value of the resistive element in ohms (Ω).\",\n      \"type\": \"number\"\n    },\n    \"current\": {\n      \"description\": \"The current flowing through the resistive element in amps (A).\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { resistance, current } = params;\n    const power = Math.pow(current, 2) * resistance;\n    return `The power dissipated in a resistive element with resistance ${resistance} ohms and current ${current} amps is ${power} watts.`;\n}','2023-10-24 21:36:24','2023-10-24 21:36:24'),(28,'{\n  \"function_description\": \"This function calculates the kinetic energy of an object given its mass and velocity.\",\n  \"parameters\": {\n    \"mass\": {\n      \"description\": \"The mass of the object in kilograms.\",\n      \"type\": \"number\"\n    },\n    \"velocity\": {\n      \"description\": \"The velocity of the object in meters per second.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { mass, velocity } = params;\n    const result = 0.5 * mass * velocity * velocity;\n    return `The kinetic energy of an object with mass ${mass} kg and velocity ${velocity} m/s is ${result} joules.`;\n}','2023-10-24 21:39:51','2023-10-24 21:39:51'),(31,'{\n  \"function_description\": \"This function calculates the mean of a given set of numbers.\",\n  \"parameters\": {\n    \"numbers\": {\n      \"description\": \"The list of numbers to calculate the mean from.\",\n      \"type\": \"array\"\n    }\n  }\n}','function executeFunction(params) {\n    const { numbers } = params;\n    const sum = numbers.reduce((a, b) => a + b, 0);\n    const mean = sum / numbers.length;\n    return `The mean of the numbers ${numbers.join(\', \')} is ${mean}.`;\n}','2023-10-24 21:43:50','2023-10-24 21:43:50'),(32,'{\n  \"function_description\": \"Calculates the standard deviation of a given set of numbers.\",\n  \"parameters\": {\n    \"numbers\": {\n      \"description\": \"The list of numbers to calculate the standard deviation from.\",\n      \"type\": \"array\"\n    }\n  }\n}','function executeFunction(params) {\n    const { numbers } = params;\n    const mean = numbers.reduce((acc, val) => acc + val, 0) / numbers.length;\n    const variance = numbers.reduce((acc, val) => acc + Math.pow(val - mean, 2), 0) / numbers.length;\n    const result = Math.sqrt(variance);\n    return `The standard deviation of [${numbers}] is ${result}.`;\n}','2023-10-24 21:44:21','2023-10-24 21:44:21'),(34,'{\n  \"function_description\": \"Calculates the number of calories in a given meal.\",\n  \"parameters\": {\n    \"carbs\": {\n      \"description\": \"The amount of carbohydrates in the meal (in grams).\",\n      \"type\": \"number\"\n    },\n    \"protein\": {\n      \"description\": \"The amount of protein in the meal (in grams).\",\n      \"type\": \"number\"\n    },\n    \"fat\": {\n      \"description\": \"The amount of fat in the meal (in grams).\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { carbs, protein, fat } = params;\n    const calories = (carbs * 4) + (protein * 4) + (fat * 9);\n    return `The meal with ${carbs}g of carbs, ${protein}g of protein, and ${fat}g of fat has ${calories} calories.`;\n}','2023-10-24 21:48:59','2023-10-24 21:48:59'),(35,'{\n  \"function_description\": \"Calculates the Body Mass Index (BMI) for a given weight and height.\",\n  \"parameters\": {\n    \"weight\": {\n      \"description\": \"The weight in kilograms.\",\n      \"type\": \"number\"\n    },\n    \"height\": {\n      \"description\": \"The height in meters.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { weight, height } = params;\n    const bmi = weight / (height * height);\n    return `For a weight of ${weight}kg and a height of ${height}m, the Body Mass Index (BMI) is ${bmi.toFixed(2)}.`;\n}','2023-10-24 21:49:32','2023-10-24 21:49:32'),(36,'{\n  \"function_description\": \"Calculates the estimated point per game (PER) for a given basketball player.\",\n  \"parameters\": {\n    \"points_per_game\": {\n      \"description\": \"The number of points scored by the basketball player on average per game.\",\n      \"type\": \"number\"\n    },\n    \"assists_per_game\": {\n      \"description\": \"The number of assists made by the basketball player on average per game.\",\n      \"type\": \"number\"\n    },\n    \"rebounds_per_game\": {\n      \"description\": \"The number of rebounds made by the basketball player on average per game.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { points_per_game, assists_per_game, rebounds_per_game } = params;\n    const estimated_PER = (points_per_game + assists_per_game + rebounds_per_game) / 3;\n    return `The estimated point per game (PER) for a basketball player who scores ${points_per_game} points, makes ${assists_per_game} assists, and ${rebounds_per_game} rebounds per game on average is ${estimated_PER.toFixed(2)}.`;\n}','2023-10-24 21:50:00','2023-10-24 21:50:00'),(38,'{\n  \"function_description\": \"This function calculates the height of a building based on its shadow length and angle of elevation.\",\n  \"parameters\": {\n    \"shadow_length\": {\n      \"description\": \"The length of the shadow in meters.\",\n      \"type\": \"number\"\n    },\n    \"angle_of_elevation\": {\n      \"description\": \"The angle of elevation in degrees.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { shadow_length, angle_of_elevation } = params;\n    const building_height = Math.tan(angle_of_elevation * Math.PI / 180) * shadow_length;\n    return `The height of the building with a shadow length of ${shadow_length} meters and an angle of elevation of ${angle_of_elevation} degrees is ${building_height} meters.`;\n}','2023-10-24 21:53:27','2023-10-24 21:53:27'),(39,'{\n  \"function_description\": \"This function calculates the maximum allowable floor area based on the given plot area and FAR.\",\n  \"parameters\": {\n    \"plot_area\": {\n      \"description\": \"The total size of the plot in square feet.\",\n      \"type\": \"number\"\n    },\n    \"far\": {\n      \"description\": \"The Floor Area Ratio (FAR) of the plot.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { plot_area, far } = params;\n    const result = plot_area * far;\n    return `The maximum allowable floor area for a plot size of ${plot_area} square feet with a FAR of ${far} is ${result} square feet.`;\n}','2023-10-24 21:55:55','2023-10-24 21:55:55'),(41,'{\n  \"function_description\": \"This function retrieves the current time.\",\n  \"parameters\": {}\n}','function executeFunction(params) {\n    const current_time = new Date();\n    return `The current time is ${current_time}.`;\n}','2023-10-24 21:59:43','2023-10-24 21:59:43'),(42,'{\n  \"function_description\": \"This function compares two numbers and returns the larger one.\",\n  \"parameters\": {\n    \"num1\": {\n      \"description\": \"The first number to compare.\",\n      \"type\": \"number\"\n    },\n    \"num2\": {\n      \"description\": \"The second number to compare.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { num1, num2 } = params;\n    let result;\n    if (num1 > num2) {\n        result = num1;\n    } else {\n        result = num2;\n    }\n    return `The larger number between ${num1} and ${num2} is ${result}.`;\n}','2023-10-24 22:00:38','2023-10-24 22:00:38'),(43,'{\n  \"function_description\": \"Calculates the quotient of two numbers.\",\n  \"parameters\": {\n    \"dividend\": {\n      \"description\": \"The dividend number.\",\n      \"type\": \"number\"\n    },\n    \"divisor\": {\n      \"description\": \"The divisor number.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { dividend, divisor } = params;\n    const result = dividend / divisor;\n    return `The quotient of ${dividend} divided by ${divisor} is ${result}.`;\n}','2023-10-25 16:25:52','2023-10-25 16:25:52'),(44,'{\n  \"function_description\": \"This function divides two numbers and returns the result.\",\n  \"parameters\": {\n    \"dividend\": {\n      \"description\": \"The dividend number to be divided.\",\n      \"type\": \"number\"\n    },\n    \"divisor\": {\n      \"description\": \"The divisor number to divide the dividend.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { dividend, divisor } = params;\n    if (divisor === 0) {\n        return \"Error: Division by zero is undefined.\";\n    }\n    const result = dividend / divisor;\n    return `The result of dividing ${dividend} by ${divisor} is ${result}.`;\n}','2023-10-25 16:30:15','2023-10-25 16:30:15'),(45,'{\n  \"function_description\": \"Calculates a number raised to a given exponent.\",\n  \"parameters\": {\n    \"base\": {\n      \"description\": \"The base of the calculation.\",\n      \"type\": \"number\"\n    },\n    \"exponent\": {\n      \"description\": \"The exponent for which to raise the number.\",\n      \"type\": \"number\"\n    }\n  }\n}','function executeFunction(params) {\n    const { base, exponent } = params;\n    const result = Math.pow(base, exponent);\n    return `The result of ${base} raised to the power of ${exponent} is ${result}.`;\n}','2023-10-25 20:39:17','2023-10-25 20:39:17');
/*!40000 ALTER TABLE `dynamic_functions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pinned_embeddings`
--

DROP TABLE IF EXISTS `pinned_embeddings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pinned_embeddings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pinned_to` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `pinned_string` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `pinned_type` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pinned_embeddings`
--

LOCK TABLES `pinned_embeddings` WRITE;
/*!40000 ALTER TABLE `pinned_embeddings` DISABLE KEYS */;
INSERT INTO `pinned_embeddings` VALUES (3,'image_generator_0','This function generates an image of a specific object.','chat_ability_function','2023-10-24 05:27:00','2023-10-24 05:27:00'),(4,'llama_v2_code_instruct_7b','System Administration: Management and maintenance of computer systems.','skill_knowledge_domain','2023-10-24 05:27:44','2023-10-24 05:27:44'),(6,'music_generator_0','This function generates dramatic entrance music for theater performances.','chat_ability_function','2023-11-08 21:57:22','2023-11-08 21:57:22'),(7,'music_generator_0','This function generates dramatic entrance music for theater performances.','chat_ability_function','2023-11-09 01:53:02','2023-11-09 01:53:02');
/*!40000 ALTER TABLE `pinned_embeddings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spellbook_module`
--

DROP TABLE IF EXISTS `spellbook_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spellbook_module` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unique_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_version` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spellbook_module`
--

LOCK TABLES `spellbook_module` WRITE;
/*!40000 ALTER TABLE `spellbook_module` DISABLE KEYS */;
INSERT INTO `spellbook_module` VALUES (51,'spellbook_skill_builder','1.0.0','available','2023-09-22 22:39:37','2023-09-22 21:17:46'),(52,'spellbook_core','1.0.0','installed','2023-09-22 21:17:46','2023-09-22 21:17:46'),(53,'spellbook_prompt','1.0.0','installed','2023-09-22 21:17:46','2023-09-22 21:17:46'),(54,'spellbook_chat_ability','1.0.0','available','2023-09-26 00:28:46','2023-09-22 21:17:46'),(55,'text_to_speech','1.0.0','available','2023-10-28 17:53:59','2023-09-22 21:17:46'),(56,'music_generator','1.0.0','available','2023-11-10 21:11:28','2023-09-22 21:17:48'),(57,'magento2_module_maker','1.0.0','available','2023-09-25 20:08:24','2023-09-22 21:17:48'),(58,'image_generator','1.0.0','available','2023-10-28 17:53:50','2023-09-22 21:17:48'),(59,'news_search','1.0.0','available','2023-11-10 21:11:17','2023-09-22 21:17:48'),(60,'current_weather','1.0.0','available','2023-11-10 21:11:19','2023-09-22 21:17:48'),(61,'language_translator','1.0.0','available','2023-10-28 17:53:52','2023-09-25 19:53:00'),(62,'apps_skill_builder','1.0.0','installed','2023-10-04 21:50:58','2023-09-26 06:25:47'),(63,'apps_chat_ability_builder','1.0.0','installed','2023-10-06 20:29:51','2023-09-26 06:25:47'),(64,'ftp_transfer','1.0.0','available','2023-10-28 17:54:53','2023-09-28 19:00:35'),(65,'telynx_sms','1.0.0','available','2023-10-28 17:53:56','2023-09-28 22:04:44'),(66,'image_analyzer','1.0.0','available','2023-10-28 17:55:02','2023-10-04 09:06:32'),(67,'wizards_wand','1.0.0','available','2023-11-10 21:11:21','2023-10-23 06:26:48');
/*!40000 ALTER TABLE `spellbook_module` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-10 14:14:47
