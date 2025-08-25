-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 25-Ago-2025 às 17:54
-- Versão do servidor: 10.4.28-MariaDB
-- versão do PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `i2c15-aion`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `activities`
--

CREATE TABLE `activities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `activityable_type` varchar(255) NOT NULL,
  `activityable_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `business_id` bigint(20) UNSIGNED DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `body` longtext DEFAULT NULL,
  `custom` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`custom`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `activity_crm_contact`
--

CREATE TABLE `activity_crm_contact` (
  `activity_id` bigint(20) UNSIGNED NOT NULL,
  `contact_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `activity_emails`
--

CREATE TABLE `activity_emails` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sender_mail` varchar(255) DEFAULT NULL,
  `recipient_mails` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`recipient_mails`)),
  `status` char(1) NOT NULL DEFAULT '1',
  `send_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `activity_log`
--

CREATE TABLE `activity_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `log_name` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `subject_type` varchar(255) DEFAULT NULL,
  `event` varchar(255) DEFAULT NULL,
  `subject_id` bigint(20) UNSIGNED DEFAULT NULL,
  `causer_type` varchar(255) DEFAULT NULL,
  `causer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `properties` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`properties`)),
  `batch_uuid` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `activity_log`
--

INSERT INTO `activity_log` (`id`, `log_name`, `description`, `subject_type`, `event`, `subject_id`, `causer_type`, `causer_id`, `properties`, `batch_uuid`, `created_at`, `updated_at`) VALUES
(1, 'auth', 'Usuário logado', 'users', 'login', 1, 'users', 1, '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/139.0.0.0 Safari\\/537.36\",\"guard\":\"web\",\"remember\":false,\"login_at\":\"2025-08-22T16:20:15+00:00\"}', NULL, '2025-08-22 19:20:15', '2025-08-22 19:20:15'),
(2, 'users', 'Novo usuário <b>Vinícius Calaça Lemos</b> cadastrado por <b>a i o n</b>', 'users', 'created', 2, 'users', 1, '{\"attributes\":{\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\",\"email\":\"emaildocalaca@gmail.com\",\"phones\":[{\"number\":\"(62) 98193-6169\",\"name\":\"Whatsapp\"}],\"updated_at\":\"2025-08-22T16:21:14.000000Z\",\"created_at\":\"2025-08-22T16:21:14.000000Z\",\"id\":2,\"roles\":[{\"id\":3,\"name\":\"Administrador\",\"pivot\":{\"model_type\":\"users\",\"model_id\":2,\"role_id\":3}}],\"address\":{\"id\":1,\"addressable_type\":\"users\",\"addressable_id\":2,\"is_main\":true,\"created_at\":\"2025-08-22T16:21:14.000000Z\",\"updated_at\":\"2025-08-22T16:21:14.000000Z\"}}}', NULL, '2025-08-22 19:21:14', '2025-08-22 19:21:14'),
(3, 'auth', 'Usuário desconectado', 'users', 'logout', 1, 'users', 1, '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/139.0.0.0 Safari\\/537.36\",\"guard\":\"web\",\"logout_at\":\"2025-08-22T16:21:24+00:00\"}', NULL, '2025-08-22 19:21:24', '2025-08-22 19:21:24'),
(4, 'auth', 'Usuário logado', 'users', 'login', 2, 'users', 2, '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/139.0.0.0 Safari\\/537.36\",\"guard\":\"web\",\"remember\":false,\"login_at\":\"2025-08-22T16:21:30+00:00\"}', NULL, '2025-08-22 19:21:30', '2025-08-22 19:21:30'),
(5, 'users', 'Usuário <b>Vinícius Calaça Lemos</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'users', 'updated', 2, 'users', 2, '{\"attributes\":{\"address\":{\"address_line\":\"Rua 9 de Julho\",\"city\":\"An\\u00e1polis\",\"district\":\"Vila S\\u00e3o Jos\\u00e9\",\"number\":\"1385\",\"slug\":\"anapolis-go\",\"uf\":\"GO\",\"updated_at\":\"2025-08-22T16:23:10.000000Z\",\"zipcode\":\"75115-525\"},\"birth_date\":\"1989-07-27\",\"citizenship\":\"Brasil\",\"complement\":\"Desenvolvedor Web Full-stack, Analista de Marketing Digital, SEO.\",\"cpf\":\"031.362.101-23\",\"educational_level\":\"3\",\"gender\":\"M\",\"marital_status\":\"2\",\"media\":[{\"collection_name\":\"avatar\",\"conversions_disk\":\"public\",\"created_at\":\"2025-08-22T16:22:16.000000Z\",\"disk\":\"public\",\"file_name\":\"vinicius-calaca-lemos-4905f94bfa016de8a15804e71cfef75d-1755879736.jpg\",\"generated_conversions\":{\"thumb\":true},\"id\":1,\"mime_type\":\"image\\/jpeg\",\"model_id\":2,\"model_type\":\"users\",\"name\":\"Lemos-avatar1\",\"order_column\":1,\"original_url\":\"http:\\/\\/127.0.0.1:8000\\/storage\\/1\\/vinicius-calaca-lemos-4905f94bfa016de8a15804e71cfef75d-1755879736.jpg\",\"size\":26396,\"updated_at\":\"2025-08-22T16:22:16.000000Z\",\"uuid\":\"f4f839bc-4f44-45a6-b11e-23734a8c432d\"}],\"nationality\":\"Brasileiro\",\"rg\":\"5112608\"},\"old\":{\"address\":{\"updated_at\":\"2025-08-22T16:21:14.000000Z\"}}}', NULL, '2025-08-22 19:23:11', '2025-08-22 19:23:11'),
(6, 'agencies', 'Nova agência <b>InCloud.sistemas</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'agencies', 'created', 1, 'users', 2, '{\"attributes\":{\"name\":\"InCloud.sistemas\",\"complement\":\"F\\u00e1brica de Software que visa transformar ideias em solu\\u00e7\\u00f5es digitais poderosas.\",\"slug\":\"incloud-sistemas\",\"updated_at\":\"2025-08-22T16:24:40.000000Z\",\"created_at\":\"2025-08-22T16:24:40.000000Z\",\"id\":1,\"users\":[{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\",\"pivot\":{\"agency_id\":1,\"user_id\":2}}]}}', NULL, '2025-08-22 19:24:40', '2025-08-22 19:24:40'),
(7, 'agencies', 'Nova agência <b>InCloud.digital</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'agencies', 'created', 2, 'users', 2, '{\"attributes\":{\"name\":\"InCloud.digital\",\"complement\":\"Consultoria em Marketing Digital dedicada a maximizar seus resultados e fazer sua empresa crescer.\",\"slug\":\"incloud-digital\",\"updated_at\":\"2025-08-22T16:25:28.000000Z\",\"created_at\":\"2025-08-22T16:25:28.000000Z\",\"id\":2,\"users\":[{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\",\"pivot\":{\"agency_id\":2,\"user_id\":2}}]}}', NULL, '2025-08-22 19:25:29', '2025-08-22 19:25:29'),
(8, 'agencies', 'Nova agência <b>I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'agencies', 'created', 3, 'users', 2, '{\"attributes\":{\"name\":\"I2C.Lares\",\"complement\":\"Hub imobili\\u00e1rio que integra site (CMS), CRM, funcionalidades financeiras e de marketing, proporcionando uma experi\\u00eancia completa e otimizada para imobili\\u00e1rias.\",\"slug\":\"i2c-lares\",\"updated_at\":\"2025-08-22T16:27:48.000000Z\",\"created_at\":\"2025-08-22T16:27:48.000000Z\",\"id\":3,\"users\":[{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\",\"pivot\":{\"agency_id\":3,\"user_id\":2}}]}}', NULL, '2025-08-22 19:27:48', '2025-08-22 19:27:48'),
(9, 'agencies', 'Nova agência <b>I2C.Koba</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'agencies', 'created', 4, 'users', 2, '{\"attributes\":{\"name\":\"I2C.Koba\",\"complement\":\"Assinaturas e agendamento online para barbearias, com pagamentos e lembretes autom\\u00e1ticos. Menos no-shows, mais receita.\",\"slug\":\"i2c-koba\",\"updated_at\":\"2025-08-22T16:39:35.000000Z\",\"created_at\":\"2025-08-22T16:39:35.000000Z\",\"id\":4,\"users\":[{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\",\"pivot\":{\"agency_id\":4,\"user_id\":2}}]}}', NULL, '2025-08-22 19:39:35', '2025-08-22 19:39:35'),
(10, 'financial_bank_accounts', 'Nova conta bancária <b>Nu Conta => VCL</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_bank_accounts', 'created', 1, 'users', 2, '{\"attributes\":{\"bank_institution_id\":\"184\",\"role\":\"1\",\"type_person\":\"1\",\"name\":\"Nu Conta => VCL\",\"balance_date\":\"2025-08-22 00:00:00\",\"is_main\":true,\"updated_at\":\"2025-08-22T16:42:34.000000Z\",\"created_at\":\"2025-08-22T16:42:34.000000Z\",\"id\":1,\"bank_institution\":{\"id\":184,\"name\":\"NU FINANCEIRA S.A. - Sociedade de Cr\\u00e9dito, Financiamento e Investimento\"}}}', NULL, '2025-08-22 19:42:34', '2025-08-22 19:42:34'),
(11, 'financial_bank_accounts', 'Nova conta bancária <b>[CORA] InC Sistemas</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_bank_accounts', 'created', 2, 'users', 2, '{\"attributes\":{\"bank_institution_id\":\"233\",\"role\":\"1\",\"type_person\":\"1\",\"agency_id\":\"1\",\"name\":\"[CORA] InC Sistemas\",\"balance_date\":\"2025-08-22 00:00:00\",\"is_main\":false,\"updated_at\":\"2025-08-22T16:43:35.000000Z\",\"created_at\":\"2025-08-22T16:43:35.000000Z\",\"id\":2,\"bank_institution\":{\"id\":233,\"name\":\"CORA SOCIEDADE DE CR\\u00c9DITO DIRETO S.A.\"},\"agency\":{\"id\":1,\"name\":\"InCloud.sistemas\"}}}', NULL, '2025-08-22 19:43:35', '2025-08-22 19:43:35'),
(12, 'financial_bank_accounts', 'Conta bancária <b>Nu Conta => VCL</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_bank_accounts', 'updated', 1, 'users', 2, '{\"attributes\":{\"type_person\":\"2\"},\"old\":{\"type_person\":\"1\"}}', NULL, '2025-08-22 19:43:54', '2025-08-22 19:43:54'),
(13, 'financial_bank_accounts', 'Nova conta bancária <b>[CORA] InC Digital</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_bank_accounts', 'created', 3, 'users', 2, '{\"attributes\":{\"bank_institution_id\":\"233\",\"role\":\"1\",\"type_person\":\"1\",\"agency_id\":\"2\",\"name\":\"[CORA] InC Digital\",\"balance_date\":\"2025-08-22 00:00:00\",\"is_main\":false,\"updated_at\":\"2025-08-22T16:44:29.000000Z\",\"created_at\":\"2025-08-22T16:44:29.000000Z\",\"id\":3,\"bank_institution\":{\"id\":233,\"name\":\"CORA SOCIEDADE DE CR\\u00c9DITO DIRETO S.A.\"},\"agency\":{\"id\":2,\"name\":\"InCloud.digital\"}}}', NULL, '2025-08-22 19:44:29', '2025-08-22 19:44:29'),
(14, 'financial_bank_accounts', 'Nova conta bancária <b>[CORA] I2C Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_bank_accounts', 'created', 4, 'users', 2, '{\"attributes\":{\"bank_institution_id\":\"233\",\"role\":\"1\",\"type_person\":\"1\",\"agency_id\":\"3\",\"name\":\"[CORA] I2C Lares\",\"balance_date\":\"2025-08-22 00:00:00\",\"is_main\":false,\"updated_at\":\"2025-08-22T16:44:56.000000Z\",\"created_at\":\"2025-08-22T16:44:56.000000Z\",\"id\":4,\"bank_institution\":{\"id\":233,\"name\":\"CORA SOCIEDADE DE CR\\u00c9DITO DIRETO S.A.\"},\"agency\":{\"id\":3,\"name\":\"I2C.Lares\"}}}', NULL, '2025-08-22 19:44:56', '2025-08-22 19:44:56'),
(15, 'financial_bank_accounts', 'Nova conta bancária <b>[CORA] I2C Koba</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_bank_accounts', 'created', 5, 'users', 2, '{\"attributes\":{\"bank_institution_id\":\"233\",\"role\":\"1\",\"type_person\":\"1\",\"agency_id\":\"4\",\"name\":\"[CORA] I2C Koba\",\"balance_date\":\"2025-08-22 00:00:00\",\"is_main\":false,\"updated_at\":\"2025-08-22T16:45:21.000000Z\",\"created_at\":\"2025-08-22T16:45:21.000000Z\",\"id\":5,\"bank_institution\":{\"id\":233,\"name\":\"CORA SOCIEDADE DE CR\\u00c9DITO DIRETO S.A.\"},\"agency\":{\"id\":4,\"name\":\"I2C.Koba\"}}}', NULL, '2025-08-22 19:45:21', '2025-08-22 19:45:21'),
(16, 'crm_contact_individuals', 'Novo contato <b>Benjamim Jorge Rodrigues Dos Santos</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 1, 'users', 2, '{\"attributes\":{\"id\":1,\"contact\":{\"id\":1,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":1,\"user_id\":2,\"source_id\":9,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\",\"email\":\"benjamim@consulteng.eng.br\",\"phones\":[{\"number\":\"(62) 99694-6129\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T16:53:13.000000Z\",\"updated_at\":\"2025-08-22T16:53:13.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":1,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":1,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}}}}', NULL, '2025-08-22 19:53:13', '2025-08-22 19:53:13'),
(17, 'crm_contact_legal_entities', 'Novo contato <b>Consulteng</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'created', 1, 'users', 2, '{\"attributes\":{\"url\":\"https:\\/\\/consulteng.eng.br\",\"sector\":\"Servi\\u00e7os\",\"id\":1,\"contact\":{\"id\":2,\"contactable_type\":\"crm_contact_legal_entities\",\"contactable_id\":1,\"user_id\":2,\"source_id\":9,\"name\":\"Consulteng\",\"status\":\"1\",\"created_at\":\"2025-08-22T16:54:43.000000Z\",\"updated_at\":\"2025-08-22T16:54:43.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":2,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"individuals\":[{\"id\":1,\"pivot\":{\"legal_entity_id\":1,\"individual_id\":1}}]}}', NULL, '2025-08-22 19:54:43', '2025-08-22 19:54:43'),
(18, 'crm_contact_individuals', 'Novo contato <b>Bruno César De Freitas</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 2, 'users', 2, '{\"attributes\":{\"cpf\":\"053.505.711-33\",\"gender\":\"M\",\"birth_date\":\"1994-04-06\",\"occupation\":\"Aut\\u00f4nomo\",\"id\":2,\"contact\":{\"id\":3,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":2,\"user_id\":2,\"source_id\":9,\"name\":\"Bruno C\\u00e9sar De Freitas\",\"email\":\"bruno.cesar.freitas@hotmail.com\",\"phones\":[{\"number\":\"(62) 99277-5756\"}],\"complement\":\"CRECI F 37.895\",\"status\":\"1\",\"created_at\":\"2025-08-22T16:58:04.000000Z\",\"updated_at\":\"2025-08-22T16:58:04.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":3,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":3,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}}}}', NULL, '2025-08-22 19:58:05', '2025-08-22 19:58:05'),
(19, 'crm_contact_individuals', 'Novo contato <b>Talita Duarte</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 3, 'users', 2, '{\"attributes\":{\"id\":3,\"contact\":{\"id\":5,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":3,\"user_id\":2,\"source_id\":9,\"name\":\"Talita Duarte\",\"email\":\"talitarrduarte@hotmail.com\",\"phones\":[{\"number\":\"(62) 62938-2877\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:00:43.000000Z\",\"updated_at\":\"2025-08-22T17:00:43.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":5,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":5,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"legal_entities\":[{\"id\":2,\"pivot\":{\"individual_id\":3,\"legal_entity_id\":2}}]}}', NULL, '2025-08-22 20:00:43', '2025-08-22 20:00:43'),
(20, 'crm_contact_legal_entities', 'Contato <b>Duarte Imóveis</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 2, 'users', 2, '{\"attributes\":{\"contact\":{\"complement\":\"CRECI J 33.048\",\"updated_at\":\"2025-08-22T17:01:29.000000Z\"},\"sector\":\"Com\\u00e9rcio\",\"url\":\"https:\\/\\/duarteimoveis.imb.br\"},\"old\":{\"contact\":{\"updated_at\":\"2025-08-22T17:00:27.000000Z\"}}}', NULL, '2025-08-22 20:01:29', '2025-08-22 20:01:29'),
(21, 'crm_contact_individuals', 'Novo contato <b>José Victor Silva Costa</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 4, 'users', 2, '{\"attributes\":{\"cpf\":\"031.338.461-40\",\"gender\":\"M\",\"birth_date\":\"1991-03-17\",\"occupation\":\"S\\u00f3cio\\/Dono\",\"id\":4,\"contact\":{\"id\":7,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":4,\"user_id\":2,\"name\":\"Jos\\u00e9 Victor Silva Costa\",\"email\":\"josevictorcorretor@gmail.com\",\"phones\":[{\"number\":\"(62) 99311-5922\"}],\"complement\":\"CRECI F. 32.357\",\"status\":\"1\",\"created_at\":\"2025-08-22T17:06:35.000000Z\",\"updated_at\":\"2025-08-22T17:06:35.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":7,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":7,\"role_id\":3}}]},\"legal_entities\":[{\"id\":3,\"pivot\":{\"individual_id\":4,\"legal_entity_id\":3}}]}}', NULL, '2025-08-22 20:06:35', '2025-08-22 20:06:35'),
(22, 'crm_contact_individuals', 'Novo contato <b>Lorrayne Stefane de Castro Moraes Souza</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 5, 'users', 2, '{\"attributes\":{\"cpf\":\"027.917.101-32\",\"gender\":\"F\",\"birth_date\":\"1989-01-25\",\"occupation\":\"Aut\\u00f4nomo\",\"id\":5,\"contact\":{\"id\":8,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":5,\"user_id\":2,\"source_id\":9,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\",\"email\":\"lorrayne.job@gmail.com\",\"phones\":[{\"number\":\"(62) 99304-8605\",\"name\":\"Whatsapp\"}],\"complement\":\"CRECI F. 34.614\",\"status\":\"1\",\"created_at\":\"2025-08-22T17:15:52.000000Z\",\"updated_at\":\"2025-08-22T17:15:52.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":8,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":8,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}}}}', NULL, '2025-08-22 20:15:52', '2025-08-22 20:15:52'),
(23, 'crm_contact_legal_entities', 'Contato <b>Imobiliária ConfLAR</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 3, 'users', 2, '{\"attributes\":{\"contact\":{\"complement\":\"CRECI J. 43.126\",\"updated_at\":\"2025-08-22T17:19:37.000000Z\"},\"sector\":\"Com\\u00e9rcio\",\"url\":\"https:\\/\\/imobiliariaconflar.com.br\\/\"},\"old\":{\"contact\":{\"updated_at\":\"2025-08-22T17:05:43.000000Z\"}}}', NULL, '2025-08-22 20:19:37', '2025-08-22 20:19:37'),
(24, 'crm_contact_individuals', 'Novo contato <b>Camila De Melo Del Fiaco</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 6, 'users', 2, '{\"attributes\":{\"gender\":\"F\",\"occupation\":\"S\\u00f3cio\\/Dono\",\"id\":6,\"contact\":{\"id\":9,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":6,\"user_id\":2,\"source_id\":9,\"name\":\"Camila De Melo Del Fiaco\",\"phones\":[{\"number\":\"(62) 99509-3443\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:22:03.000000Z\",\"updated_at\":\"2025-08-22T17:22:03.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":9,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":9,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}}}}', NULL, '2025-08-22 20:22:03', '2025-08-22 20:22:03'),
(25, 'crm_contact_individuals', 'Novo contato <b>Daniel Campos Assunção</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 7, 'users', 2, '{\"attributes\":{\"gender\":\"M\",\"occupation\":\"S\\u00f3cio\\/Dono\",\"id\":7,\"contact\":{\"id\":11,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":7,\"user_id\":2,\"source_id\":9,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\",\"email\":\"danielcampos00@gmail.com\",\"phones\":[{\"number\":\"(65) 99631-7607\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:25:27.000000Z\",\"updated_at\":\"2025-08-22T17:25:27.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":11,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":11,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"legal_entities\":[{\"id\":4,\"cnpj\":\"28.069.828\\/0001-15\",\"pivot\":{\"individual_id\":7,\"legal_entity_id\":4}}]}}', NULL, '2025-08-22 20:25:27', '2025-08-22 20:25:27'),
(26, 'crm_contact_individuals', 'Contato <b>Camila De Melo Del Fiaco</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'updated', 6, 'users', 2, '{\"attributes\":{\"contact\":{\"email\":\"tabelia@cartoriodelfiaco.com.br\",\"updated_at\":\"2025-08-22T17:27:17.000000Z\"}},\"old\":{\"contact\":{\"updated_at\":\"2025-08-22T17:22:03.000000Z\"}}}', NULL, '2025-08-22 20:27:17', '2025-08-22 20:27:17'),
(27, 'crm_contact_individuals', 'Novo contato <b>Daniel Franco Albojian</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 8, 'users', 2, '{\"attributes\":{\"gender\":\"M\",\"occupation\":\"Aut\\u00f4nomo\",\"id\":8,\"contact\":{\"id\":13,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":8,\"user_id\":2,\"source_id\":9,\"name\":\"Daniel Franco Albojian\",\"email\":\"danielfrancoalbojian@gmail.com\",\"phones\":[{\"number\":\"(31) 98916-8687\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:30:31.000000Z\",\"updated_at\":\"2025-08-22T17:30:31.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":13,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":13,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"legal_entities\":[{\"id\":5,\"pivot\":{\"individual_id\":8,\"legal_entity_id\":5}}]}}', NULL, '2025-08-22 20:30:31', '2025-08-22 20:30:31'),
(28, 'crm_contact_legal_entities', 'Novo contato <b>Exho Imóveis</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'created', 6, 'users', 2, '{\"attributes\":{\"url\":\"https:\\/\\/exho.com.br\",\"sector\":\"Com\\u00e9rcio\",\"id\":6,\"contact\":{\"id\":15,\"contactable_type\":\"crm_contact_legal_entities\",\"contactable_id\":6,\"user_id\":2,\"source_id\":9,\"name\":\"Exho Im\\u00f3veis\",\"phones\":[{\"number\":\"(62) 99239-7060\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:33:46.000000Z\",\"updated_at\":\"2025-08-22T17:33:46.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":15,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"individuals\":[{\"id\":9,\"pivot\":{\"legal_entity_id\":6,\"individual_id\":9}}]}}', NULL, '2025-08-22 20:33:46', '2025-08-22 20:33:46'),
(29, 'crm_contact_legal_entities', 'Novo contato <b>Flex Centro Empresarial</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'created', 7, 'users', 2, '{\"attributes\":{\"cnpj\":\"16.800.114\\/0001-56\",\"url\":\"https:\\/\\/flexcentroempresarial.com.br\\/\",\"id\":7,\"contact\":{\"id\":16,\"contactable_type\":\"crm_contact_legal_entities\",\"contactable_id\":7,\"user_id\":2,\"source_id\":9,\"name\":\"Flex Centro Empresarial\",\"phones\":[{\"number\":\"(62) 99845-1617\",\"name\":\"Whatsapp\"},{\"number\":\"(62) 32305-400\",\"name\":\"Fixo\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:37:31.000000Z\",\"updated_at\":\"2025-08-22T17:37:31.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":16,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}}}}', NULL, '2025-08-22 20:37:31', '2025-08-22 20:37:31'),
(30, 'crm_contact_individuals', 'Novo contato <b>Carlos Alonso</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 10, 'users', 2, '{\"attributes\":{\"gender\":\"M\",\"occupation\":\"TI\",\"id\":10,\"contact\":{\"id\":17,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":10,\"user_id\":2,\"source_id\":9,\"name\":\"Carlos Alonso\",\"email\":\"ti@ancoraengenharia.com.br\",\"phones\":[{\"number\":\"(62) 99688-7563\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:39:41.000000Z\",\"updated_at\":\"2025-08-22T17:39:41.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":17,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":17,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"legal_entities\":[{\"id\":7,\"cnpj\":\"16.800.114\\/0001-56\",\"url\":\"https:\\/\\/flexcentroempresarial.com.br\\/\",\"pivot\":{\"individual_id\":10,\"legal_entity_id\":7}}]}}', NULL, '2025-08-22 20:39:41', '2025-08-22 20:39:41'),
(31, 'crm_contact_individuals', 'Novo contato <b>Guilherme De Oliveira Nascimento</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 11, 'users', 2, '{\"attributes\":{\"gender\":\"M\",\"occupation\":\"S\\u00f3cio\\/Dono\",\"id\":11,\"contact\":{\"id\":19,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":11,\"user_id\":2,\"source_id\":9,\"name\":\"Guilherme De Oliveira Nascimento\",\"email\":\"guixkt@gmail.com\",\"phones\":[{\"number\":\"(62) 98410-9117\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:42:18.000000Z\",\"updated_at\":\"2025-08-22T17:42:18.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":19,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":19,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"legal_entities\":[{\"id\":8,\"pivot\":{\"individual_id\":11,\"legal_entity_id\":8}}]}}', NULL, '2025-08-22 20:42:18', '2025-08-22 20:42:18'),
(32, 'crm_contact_individuals', 'Novo contato <b>José Protásio Estevam Neto</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 12, 'users', 2, '{\"attributes\":{\"gender\":\"M\",\"occupation\":\"Aut\\u00f4nomo\",\"id\":12,\"contact\":{\"id\":20,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":12,\"user_id\":2,\"source_id\":9,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\",\"email\":\"contatoprota@gmail.com\",\"phones\":[{\"number\":\"(62) 99175-7202\",\"name\":\"Whatsapp\"}],\"complement\":\"CNPJ: 32.020.384\\/0001-09\",\"status\":\"1\",\"created_at\":\"2025-08-22T17:44:37.000000Z\",\"updated_at\":\"2025-08-22T17:44:37.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":20,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":20,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}}}}', NULL, '2025-08-22 20:44:37', '2025-08-22 20:44:37'),
(33, 'crm_contact_individuals', 'Novo contato <b>Leandro Batista Chaves</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 13, 'users', 2, '{\"attributes\":{\"gender\":\"M\",\"occupation\":\"Aut\\u00f4nomo\",\"id\":13,\"contact\":{\"id\":21,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":13,\"user_id\":2,\"source_id\":5,\"name\":\"Leandro Batista Chaves\",\"email\":\"contato@leandroadv.com.br\",\"phones\":[{\"number\":\"(62) 95152-828\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:46:53.000000Z\",\"updated_at\":\"2025-08-22T17:46:53.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":21,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":21,\"role_id\":3}}],\"source\":{\"id\":5,\"name\":\"Pesquisa org\\u00e2nica\"}}}}', NULL, '2025-08-22 20:46:53', '2025-08-22 20:46:53'),
(34, 'crm_contact_legal_entities', 'Novo contato <b>Oftalmo Jamous</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'created', 9, 'users', 2, '{\"attributes\":{\"cnpj\":\"43.179.744\\/0001-28\",\"url\":\"https:\\/\\/oftalmojamous.com.br\\/\",\"sector\":\"Servi\\u00e7os\",\"id\":9,\"contact\":{\"id\":23,\"contactable_type\":\"crm_contact_legal_entities\",\"contactable_id\":9,\"user_id\":2,\"source_id\":9,\"name\":\"Oftalmo Jamous\",\"email\":\"oftalmojamous20@gmail.com\",\"phones\":[{\"number\":\"(62) 99669-8269\",\"name\":\"Whatsapp\"},{\"number\":\"(62) 3937-5151\",\"name\":\"Fixo\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:51:32.000000Z\",\"updated_at\":\"2025-08-22T17:51:32.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":23,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":23,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"individuals\":[{\"id\":14,\"pivot\":{\"legal_entity_id\":9,\"individual_id\":14}}]}}', NULL, '2025-08-22 20:51:32', '2025-08-22 20:51:32'),
(35, 'crm_contact_legal_entities', 'Contato <b>Canopus Delivery Chopp</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 8, 'users', 2, '{\"attributes\":{\"contact\":{\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":18,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":18,\"role_id\":3}}],\"updated_at\":\"2025-08-22T17:51:59.000000Z\"}},\"old\":{\"contact\":{\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":18,\"role_id\":3}}],\"updated_at\":\"2025-08-22T17:41:51.000000Z\"}}}', NULL, '2025-08-22 20:51:59', '2025-08-22 20:51:59'),
(36, 'crm_contact_legal_entities', 'Contato <b>Flex Centro Empresarial</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 7, 'users', 2, '{\"attributes\":{\"contact\":{\"phones\":[{\"name\":\"Whatsapp\",\"number\":\"(62) 99845-1617\"},{\"name\":\"Fixo\",\"number\":\"(62) 3230-5400\"}],\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":16,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":16,\"role_id\":3}}],\"updated_at\":\"2025-08-22T17:52:04.000000Z\"}},\"old\":{\"contact\":{\"phones\":[{\"name\":\"Whatsapp\",\"number\":\"(62) 99845-1617\"},{\"name\":\"Fixo\",\"number\":\"(62) 32305-400\"}],\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":16,\"role_id\":3}}],\"updated_at\":\"2025-08-22T17:37:31.000000Z\"}}}', NULL, '2025-08-22 20:52:04', '2025-08-22 20:52:04'),
(37, 'crm_contact_legal_entities', 'Contato <b>Exho Imóveis</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 6, 'users', 2, '{\"attributes\":{\"contact\":{\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":15,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":15,\"role_id\":3}}]}},\"old\":{\"contact\":{\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":15,\"role_id\":3}}]}}}', NULL, '2025-08-22 20:52:07', '2025-08-22 20:52:07'),
(38, 'crm_contact_legal_entities', 'Contato <b>Elite Pisos</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 5, 'users', 2, '{\"attributes\":{\"contact\":{\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":12,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":12,\"role_id\":3}}],\"updated_at\":\"2025-08-22T17:52:27.000000Z\"}},\"old\":{\"contact\":{\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":12,\"role_id\":3}}],\"updated_at\":\"2025-08-22T17:30:17.000000Z\"}}}', NULL, '2025-08-22 20:52:27', '2025-08-22 20:52:27'),
(39, 'crm_contact_legal_entities', 'Contato <b>DCA Consultoria </b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 4, 'users', 2, '{\"attributes\":{\"contact\":{\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":10,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":10,\"role_id\":3}}],\"updated_at\":\"2025-08-22T17:52:41.000000Z\"}},\"old\":{\"contact\":{\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":10,\"role_id\":3}}],\"updated_at\":\"2025-08-22T17:25:07.000000Z\"}}}', NULL, '2025-08-22 20:52:41', '2025-08-22 20:52:41'),
(40, 'crm_contact_legal_entities', 'Contato <b>Imobiliária ConfLAR</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 3, 'users', 2, '{\"attributes\":{\"contact\":{\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":6,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":6,\"role_id\":3}}]}},\"old\":{\"contact\":{\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":6,\"role_id\":3}}]}}}', NULL, '2025-08-22 20:53:22', '2025-08-22 20:53:22'),
(41, 'crm_contact_legal_entities', 'Contato <b>Duarte Imóveis</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 2, 'users', 2, '{\"attributes\":{\"contact\":{\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":4,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":4,\"role_id\":3}}]}},\"old\":{\"contact\":{\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":4,\"role_id\":3}}]}}}', NULL, '2025-08-22 20:53:36', '2025-08-22 20:53:36'),
(42, 'crm_contact_legal_entities', 'Contato <b>Consulteng</b> atualizado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'updated', 1, 'users', 2, '{\"attributes\":{\"contact\":{\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":2,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":2,\"role_id\":3}}]}},\"old\":{\"contact\":{\"roles\":[{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":2,\"role_id\":3}}]}}}', NULL, '2025-08-22 20:53:48', '2025-08-22 20:53:48'),
(43, 'crm_contact_legal_entities', 'Novo contato <b>Prosa Produções</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_legal_entities', 'created', 10, 'users', 2, '{\"attributes\":{\"cnpj\":\"38.098.830\\/0001-76\",\"url\":\"https:\\/\\/prosaproducoes.com.br\\/\",\"sector\":\"Servi\\u00e7os\",\"id\":10,\"contact\":{\"id\":25,\"contactable_type\":\"crm_contact_legal_entities\",\"contactable_id\":10,\"user_id\":2,\"source_id\":9,\"name\":\"Prosa Produ\\u00e7\\u00f5es\",\"email\":\"prosadrive@gmail.com\",\"phones\":[{\"number\":\"(62) 99908-8067\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T17:57:57.000000Z\",\"updated_at\":\"2025-08-22T17:57:57.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":25,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":25,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"individuals\":[{\"id\":15,\"pivot\":{\"legal_entity_id\":10,\"individual_id\":15}}]}}', NULL, '2025-08-22 20:57:57', '2025-08-22 20:57:57'),
(44, 'crm_contact_individuals', 'Novo contato <b>Yan Guilherme</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 16, 'users', 2, '{\"attributes\":{\"gender\":\"M\",\"occupation\":\"Aut\\u00f4nomo\",\"id\":16,\"contact\":{\"id\":26,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":16,\"user_id\":2,\"source_id\":9,\"name\":\"Yan Guilherme\",\"email\":\"yanguilherme787@hotmail.com\",\"phones\":[{\"number\":\"(62) 98144-0525\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T18:00:31.000000Z\",\"updated_at\":\"2025-08-22T18:00:31.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":26,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":26,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}}}}', NULL, '2025-08-22 21:00:31', '2025-08-22 21:00:31'),
(45, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 1, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2025-09-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":1,\"transaction_id\":1,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":1,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":1,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(46, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 2, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2025-10-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":2,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":2,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":2,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(47, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 3, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2025-11-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":3,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":3,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":3,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(48, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 4, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2025-12-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":4,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":4,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":4,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(49, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 5, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-01-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":5,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":5,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":5,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(50, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 6, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-02-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":6,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":6,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":6,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(51, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 7, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-03-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":7,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":7,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":7,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(52, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 8, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-04-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":8,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":8,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":8,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(53, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 9, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-05-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":9,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":9,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":9,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(54, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 10, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-06-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":10,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":10,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":10,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(55, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 11, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-07-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":11,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":11,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":11,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(56, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 12, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-08-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":12,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":12,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":12,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(57, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 13, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-09-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":13,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":13,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":13,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(58, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 14, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-10-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":14,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":14,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":14,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36');
INSERT INTO `activity_log` (`id`, `log_name`, `description`, `subject_type`, `event`, `subject_id`, `causer_type`, `causer_id`, `properties`, `batch_uuid`, `created_at`, `updated_at`) VALUES
(59, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 15, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-11-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":15,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":15,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":15,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(60, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 16, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2026-12-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":16,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":16,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":16,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(61, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 17, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2027-01-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":17,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":17,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":17,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(62, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 18, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2027-02-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":18,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":18,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":18,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(63, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 19, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2027-03-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":19,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":19,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":19,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(64, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 20, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2027-04-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":20,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":20,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":20,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(65, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 21, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2027-05-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":21,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":21,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":21,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(66, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 22, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2027-06-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":22,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":22,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":22,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(67, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 23, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2027-07-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":23,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":23,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":23,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(68, 'financial_transactions', 'Nova transação <b>Gestão Marketing (tráfego Pago + Conteúdo)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 24, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"23\",\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\",\"price\":720,\"due_at\":\"2027-08-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":720,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":1,\"updated_at\":\"2025-08-22T18:03:36.000000Z\",\"created_at\":\"2025-08-22T18:03:36.000000Z\",\"id\":24,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":23,\"name\":\"Oftalmo Jamous\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":24,\"category_id\":1}},{\"id\":2,\"name\":\"Redes Sociais\",\"pivot\":{\"transaction_id\":24,\"category_id\":2}}]}}', NULL, '2025-08-22 21:03:36', '2025-08-22 21:03:36'),
(69, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 1, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:40', '2025-08-22 21:05:40'),
(70, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 2, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:40', '2025-08-22 21:05:40'),
(71, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 3, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(72, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 4, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(73, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 5, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(74, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 6, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(75, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 7, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(76, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 8, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(77, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 9, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(78, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 10, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(79, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 11, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(80, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 12, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(81, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 13, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(82, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 14, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(83, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 15, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(84, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 16, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(85, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 17, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(86, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 18, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(87, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 19, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(88, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 20, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(89, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 21, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(90, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 22, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(91, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 23, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(92, 'financial_transactions', 'Transação <b>Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 24, 'users', 2, '{\"attributes\":{\"name\":\"Gest\\u00e3o de Marketing (Tr\\u00e1fego Pago + Conte\\u00fado p\\/ Redes Sociais)\"},\"old\":{\"name\":\"Gest\\u00e3o Marketing (tr\\u00e1fego Pago + Conte\\u00fado)\"}}', NULL, '2025-08-22 21:05:41', '2025-08-22 21:05:41'),
(93, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 25, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2025-09-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":25,\"transaction_id\":25,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":25,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(94, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 26, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2025-10-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":26,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":26,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(95, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 27, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2025-11-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":27,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":27,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(96, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 28, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2025-12-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":28,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":28,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(97, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 29, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-01-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":29,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":29,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(98, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 30, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-02-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":30,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":30,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(99, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 31, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-03-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":31,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":31,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(100, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 32, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-04-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":32,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":32,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(101, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 33, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-05-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":33,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":33,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(102, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 34, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-06-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":34,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":34,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(103, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 35, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-07-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":35,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":35,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(104, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 36, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-08-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":36,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":36,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(105, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 37, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-09-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":37,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":37,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(106, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 38, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-10-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":38,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":38,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(107, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 39, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-11-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":39,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":39,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(108, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 40, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2026-12-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":40,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":40,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(109, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 41, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2027-01-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":41,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":41,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(110, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 42, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2027-02-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":42,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":42,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(111, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 43, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2027-03-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":43,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":43,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(112, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 44, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2027-04-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":44,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":44,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(113, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 45, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2027-05-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":45,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":45,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(114, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 46, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2027-06-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":46,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":46,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(115, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 47, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2027-07-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":47,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":47,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(116, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago - Canopus</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 48, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"19\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago - Canopus\",\"price\":320,\"due_at\":\"2027-08-10 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":25,\"updated_at\":\"2025-08-22T18:09:14.000000Z\",\"created_at\":\"2025-08-22T18:09:14.000000Z\",\"id\":48,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":19,\"name\":\"Guilherme De Oliveira Nascimento\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":48,\"category_id\":1}}]}}', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14'),
(117, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 49, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2025-09-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":1,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":49,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":49,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(118, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 50, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2025-10-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":50,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":50,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(119, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 51, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2025-11-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":51,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":51,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56');
INSERT INTO `activity_log` (`id`, `log_name`, `description`, `subject_type`, `event`, `subject_id`, `causer_type`, `causer_id`, `properties`, `batch_uuid`, `created_at`, `updated_at`) VALUES
(120, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 52, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2025-12-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":52,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":52,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(121, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 53, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-01-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":53,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":53,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(122, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 54, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-02-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":54,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":54,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(123, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 55, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-03-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":55,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":55,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(124, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 56, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-04-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":56,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":56,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(125, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 57, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-05-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":57,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":57,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(126, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 58, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-06-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":58,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":58,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(127, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 59, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-07-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":59,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":59,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(128, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 60, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-08-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":60,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":60,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(129, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 61, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-09-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":61,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":61,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(130, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 62, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-10-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":62,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":62,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(131, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 63, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-11-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":63,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":63,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(132, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 64, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2026-12-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":64,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":64,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(133, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 65, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2027-01-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":65,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":65,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(134, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 66, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2027-02-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":66,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":66,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(135, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 67, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2027-03-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":67,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":67,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(136, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 68, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2027-04-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":68,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":68,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(137, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 69, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2027-05-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":69,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":69,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(138, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 70, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2027-06-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":70,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":70,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(139, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 71, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2027-07-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":71,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":71,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(140, 'financial_transactions', 'Nova transação <b>Gestão de Tráfego Pago</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 72, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"25\",\"name\":\"Gest\\u00e3o de Tr\\u00e1fego Pago\",\"price\":320,\"due_at\":\"2027-08-05 00:00:00\",\"bank_account_id\":\"3\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":320,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":49,\"updated_at\":\"2025-08-22T18:10:56.000000Z\",\"created_at\":\"2025-08-22T18:10:56.000000Z\",\"id\":72,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":3,\"name\":\"[CORA] InC Digital\"},\"contact\":{\"id\":25,\"name\":\"Prosa Produ\\u00e7\\u00f5es\"},\"categories\":[{\"id\":1,\"name\":\"Tr\\u00e1fego Pago\",\"pivot\":{\"transaction_id\":72,\"category_id\":1}}]}}', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56'),
(141, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 73, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-09-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":1,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":73,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":73,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":73,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(142, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 74, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-10-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":74,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":74,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":74,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(143, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 75, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-11-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":75,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":75,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":75,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(144, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 76, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-12-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":76,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":76,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":76,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(145, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 77, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-01-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":77,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":77,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":77,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(146, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 78, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-02-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":78,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":78,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":78,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(147, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 79, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-03-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":79,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":79,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":79,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(148, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 80, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-04-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":80,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":80,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":80,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(149, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 81, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-05-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":81,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":81,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":81,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(150, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 82, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-06-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":82,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":82,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":82,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(151, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 83, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-07-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":83,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":83,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":83,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(152, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 84, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-08-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":84,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":84,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":84,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(153, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 85, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-09-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":85,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":85,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":85,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(154, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 86, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-10-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":86,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":86,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":86,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(155, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 87, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-11-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":87,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":87,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":87,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(156, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 88, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-12-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":88,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":88,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":88,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(157, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 89, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-01-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":89,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":89,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":89,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(158, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 90, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-02-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":90,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":90,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":90,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(159, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 91, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-03-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":91,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":91,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":91,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(160, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 92, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-04-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":92,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":92,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":92,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(161, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 93, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-05-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":93,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":93,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":93,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(162, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 94, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-06-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":94,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":94,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":94,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(163, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 95, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-07-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":95,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":95,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":95,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(164, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 96, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"4\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-08-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":73,\"updated_at\":\"2025-08-22T18:15:09.000000Z\",\"created_at\":\"2025-08-22T18:15:09.000000Z\",\"id\":96,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":4,\"name\":\"Duarte Im\\u00f3veis\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":96,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":96,\"category_id\":4}}]}}', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09'),
(165, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 97, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-09-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":97,\"transaction_id\":97,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":97,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":97,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(166, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 98, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-10-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":98,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":98,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":98,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(167, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 99, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-11-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":99,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":99,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":99,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01');
INSERT INTO `activity_log` (`id`, `log_name`, `description`, `subject_type`, `event`, `subject_id`, `causer_type`, `causer_id`, `properties`, `batch_uuid`, `created_at`, `updated_at`) VALUES
(168, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 100, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-12-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":100,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":100,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":100,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(169, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 101, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-01-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":101,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":101,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":101,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(170, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 102, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-02-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":102,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":102,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":102,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(171, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 103, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-03-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":103,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":103,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":103,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(172, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 104, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-04-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":104,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":104,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":104,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(173, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 105, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-05-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":105,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":105,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":105,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(174, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 106, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-06-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":106,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":106,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":106,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(175, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 107, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-07-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":107,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":107,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":107,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(176, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 108, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-08-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":108,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":108,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":108,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(177, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 109, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-09-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":109,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":109,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":109,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(178, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 110, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-10-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":110,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":110,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":110,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(179, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 111, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-11-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":111,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":111,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":111,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(180, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 112, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-12-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":112,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":112,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":112,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(181, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 113, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-01-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":113,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":113,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":113,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(182, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 114, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-02-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":114,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":114,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":114,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(183, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 115, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-03-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":115,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":115,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":115,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(184, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 116, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-04-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:01.000000Z\",\"created_at\":\"2025-08-22T18:20:01.000000Z\",\"id\":116,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":116,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":116,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01'),
(185, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 117, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-05-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:02.000000Z\",\"created_at\":\"2025-08-22T18:20:02.000000Z\",\"id\":117,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":117,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":117,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:02', '2025-08-22 21:20:02'),
(186, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 118, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-06-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:02.000000Z\",\"created_at\":\"2025-08-22T18:20:02.000000Z\",\"id\":118,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":118,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":118,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:02', '2025-08-22 21:20:02'),
(187, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 119, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-07-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:02.000000Z\",\"created_at\":\"2025-08-22T18:20:02.000000Z\",\"id\":119,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":119,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":119,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:02', '2025-08-22 21:20:02'),
(188, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 120, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"8\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-08-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":97,\"updated_at\":\"2025-08-22T18:20:02.000000Z\",\"created_at\":\"2025-08-22T18:20:02.000000Z\",\"id\":120,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":8,\"name\":\"Lorrayne Stefane de Castro Moraes Souza\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":120,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":120,\"category_id\":4}}]}}', NULL, '2025-08-22 21:20:02', '2025-08-22 21:20:02'),
(189, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 121, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-09-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":121,\"transaction_id\":121,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":121,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":121,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(190, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 122, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-10-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":122,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":122,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":122,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(191, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 123, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-11-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":123,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":123,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":123,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(192, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 124, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2025-12-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":124,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":124,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":124,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(193, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 125, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-01-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":125,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":125,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":125,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(194, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 126, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-02-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":126,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":126,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":126,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(195, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 127, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-03-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":127,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":127,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":127,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(196, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 128, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-04-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":128,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":128,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":128,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(197, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 129, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-05-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":129,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":129,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":129,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(198, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 130, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-06-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":130,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":130,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":130,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(199, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 131, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-07-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":131,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":131,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":131,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(200, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 132, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-08-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":132,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":132,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":132,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(201, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 133, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-09-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":133,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":133,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":133,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(202, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 134, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-10-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":134,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":134,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":134,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(203, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 135, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-11-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":135,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":135,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":135,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(204, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 136, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2026-12-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":136,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":136,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":136,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(205, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 137, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-01-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":137,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":137,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":137,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(206, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 138, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-02-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":138,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":138,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":138,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(207, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 139, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-03-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":139,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":139,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":139,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(208, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 140, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-04-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":140,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":140,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":140,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(209, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 141, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-05-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":141,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":141,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":141,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(210, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 142, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-06-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":142,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":142,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":142,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(211, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 143, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-07-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":143,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":143,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":143,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(212, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 144, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"7\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":75.9,\"due_at\":\"2027-08-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":75.9,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":121,\"updated_at\":\"2025-08-22T18:23:10.000000Z\",\"created_at\":\"2025-08-22T18:23:10.000000Z\",\"id\":144,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":7,\"name\":\"Jos\\u00e9 Victor Silva Costa\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":144,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":144,\"category_id\":4}}]}}', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10'),
(213, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 145, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2025-09-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":1,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":145,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":145,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":145,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07');
INSERT INTO `activity_log` (`id`, `log_name`, `description`, `subject_type`, `event`, `subject_id`, `causer_type`, `causer_id`, `properties`, `batch_uuid`, `created_at`, `updated_at`) VALUES
(214, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 146, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2025-10-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":146,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":146,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":146,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(215, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 147, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2025-11-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":147,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":147,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":147,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(216, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 148, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2025-12-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":148,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":148,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":148,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(217, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 149, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-01-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":149,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":149,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":149,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(218, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 150, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-02-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":150,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":150,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":150,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(219, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 151, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-03-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":151,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":151,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":151,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(220, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 152, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-04-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":152,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":152,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":152,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(221, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 153, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-05-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":153,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":153,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":153,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(222, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 154, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-06-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":154,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":154,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":154,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(223, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 155, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-07-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":155,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":155,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":155,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(224, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 156, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-08-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":156,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":156,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":156,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(225, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 157, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-09-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":157,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":157,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":157,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(226, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 158, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-10-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":158,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":158,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":158,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(227, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 159, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-11-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":159,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":159,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":159,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(228, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 160, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2026-12-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":160,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":160,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":160,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(229, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 161, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2027-01-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":161,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":161,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":161,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(230, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 162, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2027-02-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":162,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":162,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":162,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(231, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 163, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2027-03-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":163,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":163,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":163,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(232, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 164, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2027-04-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":164,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":164,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":164,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(233, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 165, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2027-05-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":165,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":165,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":165,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(234, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 166, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2027-06-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":166,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":166,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":166,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(235, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 167, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2027-07-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":167,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":167,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":167,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(236, 'financial_transactions', 'Nova transação <b>Mensalidade Saas I2C.Lares</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 168, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"3\",\"name\":\"Mensalidade Saas I2C.Lares\",\"price\":79.9,\"due_at\":\"2027-08-05 00:00:00\",\"bank_account_id\":\"4\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":79.9,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":145,\"updated_at\":\"2025-08-22T18:24:07.000000Z\",\"created_at\":\"2025-08-22T18:24:07.000000Z\",\"id\":168,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":4,\"name\":\"[CORA] I2C Lares\"},\"contact\":{\"id\":3,\"name\":\"Bruno C\\u00e9sar De Freitas\"},\"categories\":[{\"id\":3,\"name\":\"Saas\",\"pivot\":{\"transaction_id\":168,\"category_id\":3}},{\"id\":4,\"name\":\"I2C.Lares\",\"pivot\":{\"transaction_id\":168,\"category_id\":4}}]}}', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07'),
(237, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 169, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2025-09-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":169,\"transaction_id\":169,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":169,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(238, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 170, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2025-10-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":170,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":170,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(239, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 171, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2025-11-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":171,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":171,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(240, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 172, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2025-12-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":172,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":172,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(241, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 173, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-01-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":173,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":173,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(242, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 174, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-02-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":174,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":174,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(243, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 175, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-03-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":175,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":175,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(244, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 176, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-04-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":176,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":176,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(245, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 177, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-05-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":177,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":177,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(246, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 178, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-06-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":178,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":178,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(247, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 179, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":179,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":179,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(248, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 180, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-08-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":180,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":180,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(249, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 181, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-09-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":181,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":181,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(250, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 182, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-10-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":182,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":182,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(251, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 183, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-11-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":183,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":183,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(252, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 184, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2026-12-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":184,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":184,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(253, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 185, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2027-01-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":185,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":185,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(254, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 186, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2027-02-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":186,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":186,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(255, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 187, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2027-03-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":187,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":187,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(256, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 188, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2027-04-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":188,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":188,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(257, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 189, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2027-05-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":189,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":189,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(258, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 190, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2027-06-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":190,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":190,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42'),
(259, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 191, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2027-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:42.000000Z\",\"created_at\":\"2025-08-22T18:27:42.000000Z\",\"id\":191,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":191,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:43', '2025-08-22 21:27:43'),
(260, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://elitepisos.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 192, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"13\",\"name\":\"Hospedagem do website - https:\\/\\/elitepisos.com.br\",\"price\":25,\"due_at\":\"2027-08-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":169,\"updated_at\":\"2025-08-22T18:27:43.000000Z\",\"created_at\":\"2025-08-22T18:27:43.000000Z\",\"id\":192,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":13,\"name\":\"Daniel Franco Albojian\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem\",\"pivot\":{\"transaction_id\":192,\"category_id\":5}}]}}', NULL, '2025-08-22 21:27:43', '2025-08-22 21:27:43');
INSERT INTO `activity_log` (`id`, `log_name`, `description`, `subject_type`, `event`, `subject_id`, `causer_type`, `causer_id`, `properties`, `batch_uuid`, `created_at`, `updated_at`) VALUES
(261, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 193, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2025-09-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":193,\"transaction_id\":193,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":193,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(262, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 194, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2025-10-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":194,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":194,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(263, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 195, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2025-11-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":195,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":195,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(264, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 196, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2025-12-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":196,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":196,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(265, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 197, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-01-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":197,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":197,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(266, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 198, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-02-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":198,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":198,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(267, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 199, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-03-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":199,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":199,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(268, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 200, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-04-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":200,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":200,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(269, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 201, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-05-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":201,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":201,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(270, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 202, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":202,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":202,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(271, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 203, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-07-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":203,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":203,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(272, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 204, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-08-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":204,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":204,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(273, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 205, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-09-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":205,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":205,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(274, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 206, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-10-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":206,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":206,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(275, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 207, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-11-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":207,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":207,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(276, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 208, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2026-12-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":208,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":208,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(277, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 209, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2027-01-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":209,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":209,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(278, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 210, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2027-02-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":210,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":210,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(279, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 211, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2027-03-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":211,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":211,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(280, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 212, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2027-04-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":212,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":212,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(281, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 213, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2027-05-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":213,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":213,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(282, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 214, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2027-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":214,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":214,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(283, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 215, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2027-07-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":215,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":215,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(284, 'financial_transactions', 'Nova transação <b>Hospedagem de emails @ibericametalica.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 216, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"20\",\"name\":\"Hospedagem de emails @ibericametalica.com.br\",\"price\":25,\"due_at\":\"2027-08-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":193,\"updated_at\":\"2025-08-22T18:30:33.000000Z\",\"created_at\":\"2025-08-22T18:30:33.000000Z\",\"id\":216,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":20,\"name\":\"Jos\\u00e9 Prot\\u00e1sio Estevam Neto\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":216,\"category_id\":5}}]}}', NULL, '2025-08-22 21:30:33', '2025-08-22 21:30:33'),
(297, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 229, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2026-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":229,\"transaction_id\":229,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":229,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(298, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 230, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2027-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":230,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":230,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(299, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 231, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2028-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":231,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":231,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(300, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 232, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2029-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":232,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":232,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(301, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 233, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2030-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":233,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":233,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(302, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 234, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2031-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":234,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":234,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(303, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 235, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2032-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":235,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":235,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(304, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 236, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2033-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":236,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":236,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(305, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 237, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2034-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":237,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":237,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(306, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 238, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2035-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":238,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":238,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(307, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 239, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2036-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":239,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":239,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(308, 'financial_transactions', 'Nova transação <b>Hospedagem do website - https://flexcentroempresarial.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 240, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"16\",\"name\":\"Hospedagem do website - https:\\/\\/flexcentroempresarial.com.br (anual)\",\"price\":420,\"due_at\":\"2037-02-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":420,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":229,\"updated_at\":\"2025-08-22T18:35:48.000000Z\",\"created_at\":\"2025-08-22T18:35:48.000000Z\",\"id\":240,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":16,\"name\":\"Flex Centro Empresarial\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":240,\"category_id\":5}}]}}', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48'),
(309, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 193, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:34', '2025-08-22 21:39:34'),
(310, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 194, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(311, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 195, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(312, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 196, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(313, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 197, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(314, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 198, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(315, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 199, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(316, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 200, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(317, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 201, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(318, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 202, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(319, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 203, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(320, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 204, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(321, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 205, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(322, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 206, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(323, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 207, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(324, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 208, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(325, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 209, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(326, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 210, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(327, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 211, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(328, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 212, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(329, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 213, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(330, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 214, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(331, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 215, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(332, 'financial_transactions', 'Transação <b>Hospedagem dos emails @ibericametalica.com.br</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 216, 'users', 2, '{\"attributes\":{\"name\":\"Hospedagem dos emails @ibericametalica.com.br\"},\"old\":{\"name\":\"Hospedagem de emails @ibericametalica.com.br\"}}', NULL, '2025-08-22 21:39:56', '2025-08-22 21:39:56'),
(333, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 241, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2025-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T18:42:01.000000Z\",\"created_at\":\"2025-08-22T18:42:01.000000Z\",\"id\":241,\"transaction_id\":241,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":241,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:01', '2025-08-22 21:42:01'),
(334, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 242, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2026-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:01.000000Z\",\"created_at\":\"2025-08-22T18:42:01.000000Z\",\"id\":242,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":242,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02');
INSERT INTO `activity_log` (`id`, `log_name`, `description`, `subject_type`, `event`, `subject_id`, `causer_type`, `causer_id`, `properties`, `batch_uuid`, `created_at`, `updated_at`) VALUES
(335, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 243, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2027-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":243,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":243,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(336, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 244, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2028-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":244,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":244,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(337, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 245, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2029-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":245,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":245,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(338, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 246, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2030-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":246,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":246,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(339, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 247, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2031-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":247,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":247,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(340, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 248, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2032-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":248,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":248,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(341, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 249, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2033-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":249,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":249,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(342, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 250, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2034-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":250,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":250,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(343, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 251, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2035-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":251,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":251,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(344, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @dcaconsultoria.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 252, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"11\",\"name\":\"Hospedagem dos emails @dcaconsultoria.eng.br (anual)\",\"price\":270,\"due_at\":\"2036-08-28 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":241,\"updated_at\":\"2025-08-22T18:42:02.000000Z\",\"created_at\":\"2025-08-22T18:42:02.000000Z\",\"id\":252,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":11,\"name\":\"Daniel Campos Assun\\u00e7\\u00e3o\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":252,\"category_id\":5}}]}}', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02'),
(345, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 253, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2026-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":253,\"transaction_id\":253,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":253,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(346, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 254, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2027-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":254,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":254,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(347, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 255, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2028-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":255,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":255,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(348, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 256, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2029-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":256,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":256,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(349, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 257, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2030-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":257,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":257,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(350, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 258, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2031-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":258,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":258,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(351, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 259, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2032-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":259,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":259,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(352, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 260, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2033-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":260,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":260,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(353, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 261, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2034-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":261,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":261,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(354, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 262, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2035-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":262,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":262,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(355, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 263, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2036-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":263,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":263,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(356, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @leandroadv.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 264, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"21\",\"name\":\"Hospedagem dos emails @leandroadv.com.br (anual)\",\"price\":270,\"due_at\":\"2037-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":253,\"updated_at\":\"2025-08-22T18:44:30.000000Z\",\"created_at\":\"2025-08-22T18:44:30.000000Z\",\"id\":264,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":21,\"name\":\"Leandro Batista Chaves\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":264,\"category_id\":5}}]}}', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30'),
(357, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 265, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2025-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":1,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":265,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":265,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(358, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 266, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2026-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":266,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":266,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(359, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 267, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2027-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":267,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":267,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(360, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 268, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2028-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":268,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":268,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(361, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 269, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2029-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":269,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":269,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(362, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 270, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2030-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":270,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":270,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(363, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 271, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2031-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":271,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":271,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(364, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 272, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2032-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":272,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":272,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(365, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 273, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2033-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":273,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":273,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(366, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 274, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2034-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":274,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":274,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(367, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 275, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2035-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":275,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":275,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(368, 'financial_transactions', 'Nova transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 276, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"1\",\"name\":\"Hospedagem dos emails @consulteng.eng.br (anual)\",\"price\":216,\"due_at\":\"2036-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":216,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":265,\"updated_at\":\"2025-08-22T18:46:35.000000Z\",\"created_at\":\"2025-08-22T18:46:35.000000Z\",\"id\":276,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":1,\"name\":\"Benjamim Jorge Rodrigues Dos Santos\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":276,\"category_id\":5}}]}}', NULL, '2025-08-22 21:46:35', '2025-08-22 21:46:35'),
(369, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 277, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2026-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":1,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":277,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":277,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(370, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 278, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2027-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":278,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":278,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(371, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 279, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2028-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":279,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":279,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(372, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 280, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2029-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":280,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":280,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(373, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 281, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2030-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":281,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":281,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(374, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 282, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2031-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":282,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":282,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(375, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 283, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2032-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":283,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":283,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(376, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 284, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2033-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":284,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":284,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(377, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 285, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2034-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":285,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":285,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(378, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 286, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2035-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":286,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":286,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(379, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 287, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2036-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":287,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":287,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(380, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://paulozanella.com.br (anual)</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 288, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":27,\"name\":\"Hospedagem do website https:\\/\\/paulozanella.com.br (anual)\",\"price\":120,\"due_at\":\"2037-07-10 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":120,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":277,\"updated_at\":\"2025-08-22T18:54:02.000000Z\",\"created_at\":\"2025-08-22T18:54:02.000000Z\",\"id\":288,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":27,\"name\":\"Paulo Victor Zanella Tavares\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":288,\"category_id\":5}}]}}', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02'),
(381, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 265, 'users', 2, '{\"attributes\":{\"due_at\":\"2026-07-10 00:00:00\"},\"old\":{\"due_at\":\"2025-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(382, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 266, 'users', 2, '{\"attributes\":{\"due_at\":\"2027-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2026-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(383, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 267, 'users', 2, '{\"attributes\":{\"due_at\":\"2028-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2027-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(384, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 268, 'users', 2, '{\"attributes\":{\"due_at\":\"2029-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2028-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15');
INSERT INTO `activity_log` (`id`, `log_name`, `description`, `subject_type`, `event`, `subject_id`, `causer_type`, `causer_id`, `properties`, `batch_uuid`, `created_at`, `updated_at`) VALUES
(385, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 269, 'users', 2, '{\"attributes\":{\"due_at\":\"2030-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2029-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(386, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 270, 'users', 2, '{\"attributes\":{\"due_at\":\"2031-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2030-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(387, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 271, 'users', 2, '{\"attributes\":{\"due_at\":\"2032-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2031-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(388, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 272, 'users', 2, '{\"attributes\":{\"due_at\":\"2033-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2032-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(389, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 273, 'users', 2, '{\"attributes\":{\"due_at\":\"2034-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2033-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(390, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 274, 'users', 2, '{\"attributes\":{\"due_at\":\"2035-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2034-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(391, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 275, 'users', 2, '{\"attributes\":{\"due_at\":\"2036-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2035-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(392, 'financial_transactions', 'Transação <b>Hospedagem dos emails @consulteng.eng.br (anual)</b> atualizada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'updated', 276, 'users', 2, '{\"attributes\":{\"due_at\":\"2037-07-10T00:00:00.000000Z\"},\"old\":{\"due_at\":\"2036-07-10 00:00:00\"}}', NULL, '2025-08-22 21:58:15', '2025-08-22 21:58:15'),
(393, 'financial_transactions', 'Nova transação <b>Manutenção DNS - CDN dos emails da hospedagem @exho.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 289, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"15\",\"name\":\"Manuten\\u00e7\\u00e3o DNS - CDN dos emails da hospedagem @exho.com.br\",\"price\":300,\"due_at\":\"2025-09-15 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"1\",\"repeat_occurrence\":1,\"final_price\":300,\"user_id\":2,\"updated_at\":\"2025-08-22T19:02:54.000000Z\",\"created_at\":\"2025-08-22T19:02:54.000000Z\",\"id\":289,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":15,\"name\":\"Exho Im\\u00f3veis\"},\"categories\":[{\"id\":6,\"name\":\"Manuten\\u00e7\\u00e3o \\/ Consultoria\",\"pivot\":{\"transaction_id\":289,\"category_id\":6}}]}}', NULL, '2025-08-22 22:02:54', '2025-08-22 22:02:54'),
(394, 'crm_contact_individuals', 'Novo contato <b>Márcio Franco</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 18, 'users', 2, '{\"attributes\":{\"gender\":\"M\",\"occupation\":\"Aut\\u00f4nomo\",\"id\":18,\"contact\":{\"id\":29,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":18,\"user_id\":2,\"source_id\":9,\"name\":\"M\\u00e1rcio Franco\",\"phones\":[{\"number\":\"(31) 97599-3678\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T19:08:49.000000Z\",\"updated_at\":\"2025-08-22T19:08:49.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":29,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":29,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"legal_entities\":[{\"id\":11,\"pivot\":{\"individual_id\":18,\"legal_entity_id\":11}}]}}', NULL, '2025-08-22 22:08:49', '2025-08-22 22:08:49'),
(395, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 290, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2025-08-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":1,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":290,\"transaction_id\":290,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":290,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(396, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 291, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2025-09-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":2,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":291,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":291,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(397, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 292, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2025-10-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":3,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":292,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":292,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(398, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 293, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2025-11-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":4,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":293,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":293,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(399, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 294, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2025-12-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":5,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":294,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":294,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(400, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 295, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-01-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":6,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":295,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":295,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(401, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 296, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-02-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":7,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":296,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":296,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(402, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 297, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-03-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":8,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":297,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":297,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(403, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 298, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-04-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":9,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":298,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":298,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(404, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 299, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-05-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":10,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":299,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":299,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(405, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 300, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-06-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":11,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":300,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":300,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(406, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 301, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-07-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":12,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":301,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":301,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(407, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 302, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-08-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":13,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":302,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":302,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(408, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 303, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-09-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":14,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":303,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":303,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(409, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 304, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-10-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":15,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":304,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":304,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(410, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 305, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-11-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":16,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":305,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":305,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(411, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 306, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2026-12-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":17,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":306,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":306,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(412, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 307, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2027-01-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":18,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":307,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":307,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(413, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 308, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2027-02-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":19,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":308,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":308,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(414, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 309, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2027-03-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":20,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":309,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":309,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(415, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 310, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2027-04-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":21,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":310,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":310,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(416, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 311, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2027-05-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":22,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":311,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":311,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(417, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 312, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2027-06-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":23,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":312,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":312,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(418, 'financial_transactions', 'Nova transação <b>Hospedagem do website https://estruturalpisosevidros.com.br</b> cadastrada por <b>Vinícius Calaça Lemos</b>', 'financial_transactions', 'created', 313, 'users', 2, '{\"attributes\":{\"role\":2,\"contact_id\":\"29\",\"name\":\"Hospedagem do website https:\\/\\/estruturalpisosevidros.com.br\",\"price\":25,\"due_at\":\"2027-07-20 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"3\",\"repeat_occurrence\":\"24\",\"final_price\":25,\"user_id\":2,\"repeat_index\":24,\"transaction_id\":290,\"updated_at\":\"2025-08-22T19:11:19.000000Z\",\"created_at\":\"2025-08-22T19:11:19.000000Z\",\"id\":313,\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":29,\"name\":\"M\\u00e1rcio Franco\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":313,\"category_id\":5}}]}}', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19'),
(419, 'crm_contact_individuals', 'Novo contato <b>Pedro Henrique Felix Frazão</b> cadastrado por <b>Vinícius Calaça Lemos</b>', 'crm_contact_individuals', 'created', 19, 'users', 2, '{\"attributes\":{\"gender\":\"M\",\"occupation\":\"Aut\\u00f4nomo\",\"id\":19,\"contact\":{\"id\":30,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":19,\"user_id\":2,\"name\":\"Pedro Henrique Felix Fraz\\u00e3o\",\"phones\":[{\"number\":\"(62) 98213-3373\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-22T19:18:42.000000Z\",\"updated_at\":\"2025-08-22T19:18:42.000000Z\",\"owner\":{\"id\":2,\"name\":\"Vin\\u00edcius Cala\\u00e7a Lemos\"},\"roles\":[{\"id\":4,\"name\":\"Fornecedor\",\"pivot\":{\"contact_id\":30,\"role_id\":4}}]}}}', NULL, '2025-08-22 22:18:42', '2025-08-22 22:18:42'),
(420, 'auth', 'Usuário logado', 'users', 'login', 1, 'users', 1, '{\"ip\":\"127.0.0.1\",\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/139.0.0.0 Safari\\/537.36\",\"guard\":\"web\",\"remember\":false,\"login_at\":\"2025-08-25T14:51:56+00:00\"}', NULL, '2025-08-25 17:51:56', '2025-08-25 17:51:56'),
(421, 'crm_contact_individuals', 'Novo contato <b>Renata Diniz</b> cadastrado por <b>a i o n</b>', 'crm_contact_individuals', 'created', 20, 'users', 1, '{\"attributes\":{\"id\":20,\"contact\":{\"id\":32,\"contactable_type\":\"crm_contact_individuals\",\"contactable_id\":20,\"user_id\":1,\"source_id\":9,\"name\":\"Renata Diniz\",\"phones\":[{\"number\":\"(31) 98817-2539\",\"name\":\"Whatsapp\"}],\"status\":\"1\",\"created_at\":\"2025-08-25T15:22:14.000000Z\",\"updated_at\":\"2025-08-25T15:22:14.000000Z\",\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"roles\":[{\"id\":1,\"name\":\"Assinante\",\"pivot\":{\"contact_id\":32,\"role_id\":1}},{\"id\":3,\"name\":\"Cliente\",\"pivot\":{\"contact_id\":32,\"role_id\":3}}],\"source\":{\"id\":9,\"name\":\"Refer\\u00eancias\"}},\"legal_entities\":[{\"id\":12,\"cnpj\":\"55.535.743\\/0001-58\",\"pivot\":{\"individual_id\":20,\"legal_entity_id\":12}}]}}', NULL, '2025-08-25 18:22:14', '2025-08-25 18:22:14'),
(422, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 314, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2026-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":1,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":314,\"transaction_id\":314,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":314,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(423, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 315, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2027-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":2,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":315,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":315,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(424, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 316, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2028-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":3,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":316,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":316,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(425, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 317, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2029-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":4,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":317,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":317,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(426, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 318, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2030-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":5,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":318,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":318,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(427, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 319, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2031-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":6,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":319,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":319,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(428, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 320, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2032-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":7,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":320,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":320,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(429, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 321, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2033-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":8,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":321,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":321,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(430, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 322, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2034-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":9,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":322,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":322,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(431, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 323, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2035-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":10,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":323,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":323,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(432, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 324, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2036-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":11,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":324,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":324,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59'),
(433, 'financial_transactions', 'Nova transação <b>Hospedagem dos e-mails @nobisarquitetura.com.br (anual)</b> cadastrada por <b>a i o n</b>', 'financial_transactions', 'created', 325, 'users', 1, '{\"attributes\":{\"role\":2,\"contact_id\":\"32\",\"name\":\"Hospedagem dos e-mails @nobisarquitetura.com.br (anual)\",\"price\":270,\"due_at\":\"2037-06-05 00:00:00\",\"bank_account_id\":\"2\",\"payment_method\":\"4\",\"repeat_payment\":\"3\",\"repeat_frequency\":\"7\",\"repeat_occurrence\":\"12\",\"final_price\":270,\"user_id\":1,\"repeat_index\":12,\"transaction_id\":314,\"updated_at\":\"2025-08-25T15:30:59.000000Z\",\"created_at\":\"2025-08-25T15:30:59.000000Z\",\"id\":325,\"owner\":{\"id\":1,\"name\":\"a i o n\"},\"bank_account\":{\"id\":2,\"name\":\"[CORA] InC Sistemas\"},\"contact\":{\"id\":32,\"name\":\"Renata Diniz\"},\"categories\":[{\"id\":5,\"name\":\"Hospedagem de Sites\",\"pivot\":{\"transaction_id\":325,\"category_id\":5}}]}}', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59');

-- --------------------------------------------------------

--
-- Estrutura da tabela `activity_notes`
--

CREATE TABLE `activity_notes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role` char(1) NOT NULL,
  `register_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `activity_tasks`
--

CREATE TABLE `activity_tasks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `task_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role` char(1) NOT NULL,
  `start_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_date` date DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `repeat_occurrence` int(11) NOT NULL DEFAULT 1,
  `repeat_frequency` char(1) DEFAULT NULL,
  `repeat_index` int(11) NOT NULL DEFAULT 1,
  `location` varchar(255) DEFAULT NULL,
  `priority` char(1) DEFAULT NULL,
  `reminders` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`reminders`)),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `activity_user`
--

CREATE TABLE `activity_user` (
  `activity_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `addresses`
--

CREATE TABLE `addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `addressable_type` varchar(255) NOT NULL,
  `addressable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `is_main` tinyint(1) NOT NULL DEFAULT 0,
  `zipcode` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `address_line` varchar(255) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `complement` varchar(255) DEFAULT NULL,
  `custom_street` varchar(255) DEFAULT NULL,
  `custom_block` varchar(255) DEFAULT NULL,
  `custom_lot` varchar(255) DEFAULT NULL,
  `reference` varchar(255) DEFAULT NULL,
  `gmap_coordinates` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `addresses`
--

INSERT INTO `addresses` (`id`, `addressable_type`, `addressable_id`, `name`, `slug`, `is_main`, `zipcode`, `state`, `uf`, `city`, `country`, `district`, `address_line`, `number`, `complement`, `custom_street`, `custom_block`, `custom_lot`, `reference`, `gmap_coordinates`, `created_at`, `updated_at`) VALUES
(1, 'users', 2, NULL, 'anapolis-go', 1, '75115-525', NULL, 'GO', 'Anápolis', NULL, 'Vila São José', 'Rua 9 de Julho', '1385', NULL, NULL, NULL, NULL, NULL, NULL, '2025-08-22 19:21:14', '2025-08-22 19:23:10');

-- --------------------------------------------------------

--
-- Estrutura da tabela `agencies`
--

CREATE TABLE `agencies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `complement` text DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '1',
  `custom` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`custom`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `agencies`
--

INSERT INTO `agencies` (`id`, `name`, `slug`, `complement`, `status`, `custom`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'InCloud.sistemas', 'incloud-sistemas', 'Fábrica de Software que visa transformar ideias em soluções digitais poderosas.', '1', NULL, '2025-08-22 19:24:40', '2025-08-22 19:24:40', NULL),
(2, 'InCloud.digital', 'incloud-digital', 'Consultoria em Marketing Digital dedicada a maximizar seus resultados e fazer sua empresa crescer.', '1', NULL, '2025-08-22 19:25:28', '2025-08-22 19:25:28', NULL),
(3, 'I2C.Lares', 'i2c-lares', 'Hub imobiliário que integra site (CMS), CRM, funcionalidades financeiras e de marketing, proporcionando uma experiência completa e otimizada para imobiliárias.', '1', NULL, '2025-08-22 19:27:48', '2025-08-22 19:27:48', NULL),
(4, 'I2C.Koba', 'i2c-koba', 'Assinaturas e agendamento online para barbearias, com pagamentos e lembretes automáticos. Menos no-shows, mais receita.', '1', NULL, '2025-08-22 19:39:35', '2025-08-22 19:39:35', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `agency_user`
--

CREATE TABLE `agency_user` (
  `agency_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `agency_user`
--

INSERT INTO `agency_user` (`agency_id`, `user_id`) VALUES
(1, 2),
(2, 2),
(3, 2),
(4, 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('a_i_o_n_cms_marketing_vendas_e_crm_cache_da4b9237bacccdf19c0760cab7aec4a8359010b0', 'i:1;', 1755890543),
('a_i_o_n_cms_marketing_vendas_e_crm_cache_da4b9237bacccdf19c0760cab7aec4a8359010b0:timer', 'i:1755890543;', 1755890543),
('a_i_o_n_cms_marketing_vendas_e_crm_cache_livewire-rate-limiter:a17961fa74e9275d529f489537f179c05d50c2f3', 'i:1;', 1756133574),
('a_i_o_n_cms_marketing_vendas_e_crm_cache_livewire-rate-limiter:a17961fa74e9275d529f489537f179c05d50c2f3:timer', 'i:1756133574;', 1756133574),
('a_i_o_n_cms_marketing_vendas_e_crm_cache_spatie.permission.cache', 'a:3:{s:5:\"alias\";a:4:{s:1:\"a\";s:2:\"id\";s:1:\"b\";s:4:\"name\";s:1:\"c\";s:10:\"guard_name\";s:1:\"r\";s:5:\"roles\";}s:11:\"permissions\";a:52:{i:0;a:4:{s:1:\"a\";i:1;s:1:\"b\";s:19:\"Cadastrar Usuários\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:1;a:4:{s:1:\"a\";i:2;s:1:\"b\";s:20:\"Visualizar Usuários\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:2;a:4:{s:1:\"a\";i:3;s:1:\"b\";s:16:\"Editar Usuários\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:3;a:4:{s:1:\"a\";i:4;s:1:\"b\";s:17:\"Deletar Usuários\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:4;a:4:{s:1:\"a\";i:5;s:1:\"b\";s:28:\"Cadastrar Níveis de Acessos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:5;a:4:{s:1:\"a\";i:6;s:1:\"b\";s:29:\"Visualizar Níveis de Acessos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:6;a:4:{s:1:\"a\";i:7;s:1:\"b\";s:25:\"Editar Níveis de Acessos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:7;a:4:{s:1:\"a\";i:8;s:1:\"b\";s:26:\"Deletar Níveis de Acessos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:8;a:4:{s:1:\"a\";i:9;s:1:\"b\";s:19:\"Cadastrar Agências\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:9;a:4:{s:1:\"a\";i:10;s:1:\"b\";s:20:\"Visualizar Agências\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:10;a:4:{s:1:\"a\";i:11;s:1:\"b\";s:16:\"Editar Agências\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:11;a:4:{s:1:\"a\";i:12;s:1:\"b\";s:17:\"Deletar Agências\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:12;a:4:{s:1:\"a\";i:13;s:1:\"b\";s:17:\"Cadastrar Equipes\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:13;a:4:{s:1:\"a\";i:14;s:1:\"b\";s:18:\"Visualizar Equipes\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:14;a:4:{s:1:\"a\";i:15;s:1:\"b\";s:14:\"Editar Equipes\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:15;a:4:{s:1:\"a\";i:16;s:1:\"b\";s:15:\"Deletar Equipes\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:16;a:4:{s:1:\"a\";i:17;s:1:\"b\";s:46:\"Cadastrar [CRM] Origens dos Contatos/Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:17;a:4:{s:1:\"a\";i:18;s:1:\"b\";s:47:\"Visualizar [CRM] Origens dos Contatos/Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:18;a:4:{s:1:\"a\";i:19;s:1:\"b\";s:43:\"Editar [CRM] Origens dos Contatos/Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:19;a:4:{s:1:\"a\";i:20;s:1:\"b\";s:44:\"Deletar [CRM] Origens dos Contatos/Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:20;a:4:{s:1:\"a\";i:21;s:1:\"b\";s:33:\"Cadastrar [CRM] Tipos de Contatos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:21;a:4:{s:1:\"a\";i:22;s:1:\"b\";s:34:\"Visualizar [CRM] Tipos de Contatos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:22;a:4:{s:1:\"a\";i:23;s:1:\"b\";s:30:\"Editar [CRM] Tipos de Contatos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:23;a:4:{s:1:\"a\";i:24;s:1:\"b\";s:31:\"Deletar [CRM] Tipos de Contatos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:24;a:4:{s:1:\"a\";i:25;s:1:\"b\";s:24:\"Cadastrar [CRM] Contatos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:5:{i:0;i:1;i:1;i:3;i:2;i:4;i:3;i:5;i:4;i:6;}}i:25;a:4:{s:1:\"a\";i:26;s:1:\"b\";s:25:\"Visualizar [CRM] Contatos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:5:{i:0;i:1;i:1;i:3;i:2;i:4;i:3;i:5;i:4;i:6;}}i:26;a:4:{s:1:\"a\";i:27;s:1:\"b\";s:21:\"Editar [CRM] Contatos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:5:{i:0;i:1;i:1;i:3;i:2;i:4;i:3;i:5;i:4;i:6;}}i:27;a:4:{s:1:\"a\";i:28;s:1:\"b\";s:22:\"Deletar [CRM] Contatos\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:5:{i:0;i:1;i:1;i:3;i:2;i:4;i:3;i:5;i:4;i:6;}}i:28;a:4:{s:1:\"a\";i:29;s:1:\"b\";s:34:\"Cadastrar [CRM] Funis de Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:29;a:4:{s:1:\"a\";i:30;s:1:\"b\";s:35:\"Visualizar [CRM] Funis de Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:30;a:4:{s:1:\"a\";i:31;s:1:\"b\";s:31:\"Editar [CRM] Funis de Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:31;a:4:{s:1:\"a\";i:32;s:1:\"b\";s:32:\"Deletar [CRM] Funis de Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:3;}}i:32;a:4:{s:1:\"a\";i:33;s:1:\"b\";s:25:\"Cadastrar [CRM] Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:5:{i:0;i:1;i:1;i:3;i:2;i:4;i:3;i:5;i:4;i:6;}}i:33;a:4:{s:1:\"a\";i:34;s:1:\"b\";s:26:\"Visualizar [CRM] Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:5:{i:0;i:1;i:1;i:3;i:2;i:4;i:3;i:5;i:4;i:6;}}i:34;a:4:{s:1:\"a\";i:35;s:1:\"b\";s:22:\"Editar [CRM] Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:5:{i:0;i:1;i:1;i:3;i:2;i:4;i:3;i:5;i:4;i:6;}}i:35;a:4:{s:1:\"a\";i:36;s:1:\"b\";s:23:\"Deletar [CRM] Negócios\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:5:{i:0;i:1;i:1;i:3;i:2;i:4;i:3;i:5;i:4;i:6;}}i:36;a:4:{s:1:\"a\";i:37;s:1:\"b\";s:48:\"Cadastrar [Financeiro] Instituições Bancárias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:37;a:4:{s:1:\"a\";i:38;s:1:\"b\";s:49:\"Visualizar [Financeiro] Instituições Bancárias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:38;a:4:{s:1:\"a\";i:39;s:1:\"b\";s:45:\"Editar [Financeiro] Instituições Bancárias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:39;a:4:{s:1:\"a\";i:40;s:1:\"b\";s:46:\"Deletar [Financeiro] Instituições Bancárias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:1:{i:0;i:1;}}i:40;a:4:{s:1:\"a\";i:41;s:1:\"b\";s:40:\"Cadastrar [Financeiro] Contas Bancárias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:41;a:4:{s:1:\"a\";i:42;s:1:\"b\";s:41:\"Visualizar [Financeiro] Contas Bancárias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:42;a:4:{s:1:\"a\";i:43;s:1:\"b\";s:37:\"Editar [Financeiro] Contas Bancárias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:43;a:4:{s:1:\"a\";i:44;s:1:\"b\";s:38:\"Deletar [Financeiro] Contas Bancárias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:44;a:4:{s:1:\"a\";i:45;s:1:\"b\";s:47:\"Cadastrar [Financeiro] Transações Financeiras\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:45;a:4:{s:1:\"a\";i:46;s:1:\"b\";s:48:\"Visualizar [Financeiro] Transações Financeiras\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:46;a:4:{s:1:\"a\";i:47;s:1:\"b\";s:44:\"Editar [Financeiro] Transações Financeiras\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:47;a:4:{s:1:\"a\";i:48;s:1:\"b\";s:45:\"Deletar [Financeiro] Transações Financeiras\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:48;a:4:{s:1:\"a\";i:49;s:1:\"b\";s:33:\"Cadastrar [Financeiro] Categorias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:49;a:4:{s:1:\"a\";i:50;s:1:\"b\";s:34:\"Visualizar [Financeiro] Categorias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:50;a:4:{s:1:\"a\";i:51;s:1:\"b\";s:30:\"Editar [Financeiro] Categorias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}i:51;a:4:{s:1:\"a\";i:52;s:1:\"b\";s:31:\"Deletar [Financeiro] Categorias\";s:1:\"c\";s:3:\"web\";s:1:\"r\";a:3:{i:0;i:1;i:1;i:3;i:2;i:7;}}}s:5:\"roles\";a:6:{i:0;a:3:{s:1:\"a\";i:1;s:1:\"b\";s:18:\"Superadministrador\";s:1:\"c\";s:3:\"web\";}i:1;a:3:{s:1:\"a\";i:3;s:1:\"b\";s:13:\"Administrador\";s:1:\"c\";s:3:\"web\";}i:2;a:3:{s:1:\"a\";i:4;s:1:\"b\";s:6:\"Líder\";s:1:\"c\";s:3:\"web\";}i:3;a:3:{s:1:\"a\";i:5;s:1:\"b\";s:11:\"Coordenador\";s:1:\"c\";s:3:\"web\";}i:4;a:3:{s:1:\"a\";i:6;s:1:\"b\";s:11:\"Colaborador\";s:1:\"c\";s:3:\"web\";}i:5;a:3:{s:1:\"a\";i:7;s:1:\"b\";s:10:\"Financeiro\";s:1:\"c\";s:3:\"web\";}}}', 1756219917);

-- --------------------------------------------------------

--
-- Estrutura da tabela `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_business`
--

CREATE TABLE `crm_business` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `contact_id` bigint(20) UNSIGNED NOT NULL,
  `funnel_id` bigint(20) UNSIGNED NOT NULL,
  `funnel_stage_id` bigint(20) UNSIGNED NOT NULL,
  `funnel_substage_id` bigint(20) UNSIGNED DEFAULT NULL,
  `source_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `commission_percentage` int(11) DEFAULT NULL,
  `commission_price` bigint(20) DEFAULT NULL,
  `priority` char(1) DEFAULT NULL,
  `order` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `business_at` timestamp NOT NULL DEFAULT '2025-08-22 19:19:21',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_business_funnel_stages`
--

CREATE TABLE `crm_business_funnel_stages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `business_id` bigint(20) UNSIGNED NOT NULL,
  `funnel_id` bigint(20) UNSIGNED NOT NULL,
  `funnel_stage_id` bigint(20) UNSIGNED NOT NULL,
  `funnel_substage_id` bigint(20) UNSIGNED DEFAULT NULL,
  `loss_reason` int(11) DEFAULT NULL,
  `business_at` timestamp NOT NULL DEFAULT '2025-08-22 19:19:21',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_business_user`
--

CREATE TABLE `crm_business_user` (
  `business_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `business_at` timestamp NOT NULL DEFAULT '2025-08-22 19:19:21'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_contacts`
--

CREATE TABLE `crm_contacts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `contactable_type` varchar(255) NOT NULL,
  `contactable_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `source_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `additional_emails` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional_emails`)),
  `phones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`phones`)),
  `complement` text DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '1',
  `custom` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`custom`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_contacts`
--

INSERT INTO `crm_contacts` (`id`, `contactable_type`, `contactable_id`, `user_id`, `source_id`, `name`, `email`, `additional_emails`, `phones`, `complement`, `status`, `custom`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'crm_contact_individuals', 1, 2, 9, 'Benjamim Jorge Rodrigues Dos Santos', 'benjamim@consulteng.eng.br', '[]', '[{\"number\":\"(62) 99694-6129\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 19:53:13', '2025-08-22 19:53:13', NULL),
(2, 'crm_contact_legal_entities', 1, 2, 9, 'Consulteng', NULL, '[]', '[{\"number\":null,\"name\":null}]', NULL, '1', NULL, '2025-08-22 19:54:43', '2025-08-22 19:54:43', NULL),
(3, 'crm_contact_individuals', 2, 2, 9, 'Bruno César De Freitas', 'bruno.cesar.freitas@hotmail.com', '[]', '[{\"number\":\"(62) 99277-5756\",\"name\":null}]', 'CRECI F 37.895', '1', NULL, '2025-08-22 19:58:04', '2025-08-22 19:58:04', NULL),
(4, 'crm_contact_legal_entities', 2, 2, 9, 'Duarte Imóveis', 'contato@duarteimoveis.imb.br', '[]', '[{\"name\":null,\"number\":\"(62) 99209-0156\"}]', 'CRECI J 33.048', '1', NULL, '2025-08-22 20:00:27', '2025-08-22 20:01:29', NULL),
(5, 'crm_contact_individuals', 3, 2, 9, 'Talita Duarte', 'talitarrduarte@hotmail.com', '[]', '[{\"number\":\"(62) 62938-2877\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 20:00:43', '2025-08-22 20:00:43', NULL),
(6, 'crm_contact_legal_entities', 3, 2, 9, 'Imobiliária ConfLAR', 'contato@imobiliariaconflar.com.br', '[]', '[{\"name\":null,\"number\":\"(62) 99514-7744\"}]', 'CRECI J. 43.126', '1', NULL, '2025-08-22 20:05:43', '2025-08-22 20:19:37', NULL),
(7, 'crm_contact_individuals', 4, 2, NULL, 'José Victor Silva Costa', 'josevictorcorretor@gmail.com', '[]', '[{\"number\":\"(62) 99311-5922\",\"name\":null}]', 'CRECI F. 32.357', '1', NULL, '2025-08-22 20:06:35', '2025-08-22 20:06:35', NULL),
(8, 'crm_contact_individuals', 5, 2, 9, 'Lorrayne Stefane de Castro Moraes Souza', 'lorrayne.job@gmail.com', '[]', '[{\"number\":\"(62) 99304-8605\",\"name\":\"Whatsapp\"}]', 'CRECI F. 34.614', '1', NULL, '2025-08-22 20:15:52', '2025-08-22 20:15:52', NULL),
(9, 'crm_contact_individuals', 6, 2, 9, 'Camila De Melo Del Fiaco', 'tabelia@cartoriodelfiaco.com.br', '[]', '[{\"number\":\"(62) 99509-3443\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 20:22:03', '2025-08-22 20:27:17', NULL),
(10, 'crm_contact_legal_entities', 4, 2, 9, 'DCA Consultoria ', NULL, '[]', '[{\"name\":null,\"number\":null}]', NULL, '1', NULL, '2025-08-22 20:25:07', '2025-08-22 20:52:41', NULL),
(11, 'crm_contact_individuals', 7, 2, 9, 'Daniel Campos Assunção', 'danielcampos00@gmail.com', '[]', '[{\"number\":\"(65) 99631-7607\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 20:25:27', '2025-08-22 20:25:27', NULL),
(12, 'crm_contact_legal_entities', 5, 2, 9, 'Elite Pisos', 'contato@elitepisos.com.br', '[]', '[{\"name\":null,\"number\":\"(31) 98390-9551\"}]', NULL, '1', NULL, '2025-08-22 20:30:17', '2025-08-22 20:52:27', NULL),
(13, 'crm_contact_individuals', 8, 2, 9, 'Daniel Franco Albojian', 'danielfrancoalbojian@gmail.com', '[]', '[{\"number\":\"(31) 98916-8687\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 20:30:31', '2025-08-22 20:30:31', NULL),
(14, 'crm_contact_individuals', 9, 2, 9, 'Sávio Barbosa', 'sv@exho.com.br', NULL, '[{\"name\":null,\"number\":\"(62) 99267-6224\"}]', NULL, '1', NULL, '2025-08-22 20:33:36', '2025-08-22 20:33:36', NULL),
(15, 'crm_contact_legal_entities', 6, 2, 9, 'Exho Imóveis', NULL, '[]', '[{\"number\":\"(62) 99239-7060\",\"name\":null}]', NULL, '1', NULL, '2025-08-22 20:33:46', '2025-08-22 20:33:46', NULL),
(16, 'crm_contact_legal_entities', 7, 2, 9, 'Flex Centro Empresarial', NULL, '[]', '[{\"number\":\"(62) 99845-1617\",\"name\":\"Whatsapp\"},{\"number\":\"(62) 3230-5400\",\"name\":\"Fixo\"}]', NULL, '1', NULL, '2025-08-22 20:37:31', '2025-08-22 20:52:04', NULL),
(17, 'crm_contact_individuals', 10, 2, 9, 'Carlos Alonso', 'ti@ancoraengenharia.com.br', '[]', '[{\"number\":\"(62) 99688-7563\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 20:39:41', '2025-08-22 20:39:41', NULL),
(18, 'crm_contact_legal_entities', 8, 2, 9, 'Canopus Delivery Chopp', NULL, '[]', '[{\"name\":null,\"number\":null}]', NULL, '1', NULL, '2025-08-22 20:41:51', '2025-08-22 20:51:59', NULL),
(19, 'crm_contact_individuals', 11, 2, 9, 'Guilherme De Oliveira Nascimento', 'guixkt@gmail.com', '[]', '[{\"number\":\"(62) 98410-9117\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 20:42:18', '2025-08-22 20:42:18', NULL),
(20, 'crm_contact_individuals', 12, 2, 9, 'José Protásio Estevam Neto', 'contatoprota@gmail.com', '[]', '[{\"number\":\"(62) 99175-7202\",\"name\":\"Whatsapp\"}]', 'CNPJ: 32.020.384/0001-09', '1', NULL, '2025-08-22 20:44:37', '2025-08-22 20:44:37', NULL),
(21, 'crm_contact_individuals', 13, 2, 5, 'Leandro Batista Chaves', 'contato@leandroadv.com.br', '[]', '[{\"number\":\"(62) 95152-828\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 20:46:53', '2025-08-22 20:46:53', NULL),
(22, 'crm_contact_individuals', 14, 2, 9, 'Dr. Raphael Resende', NULL, NULL, '[{\"name\":null,\"number\":\"(62) 99680-5311\"}]', NULL, '1', NULL, '2025-08-22 20:51:20', '2025-08-22 20:51:20', NULL),
(23, 'crm_contact_legal_entities', 9, 2, 9, 'Oftalmo Jamous', 'oftalmojamous20@gmail.com', '[]', '[{\"number\":\"(62) 99669-8269\",\"name\":\"Whatsapp\"},{\"number\":\"(62) 3937-5151\",\"name\":\"Fixo\"}]', NULL, '1', NULL, '2025-08-22 20:51:32', '2025-08-22 20:51:32', NULL),
(24, 'crm_contact_individuals', 15, 2, 9, 'Amanda Milanez', NULL, NULL, '[{\"name\":null,\"number\":\"(62) 99122-0233\"}]', NULL, '1', NULL, '2025-08-22 20:57:33', '2025-08-22 20:57:33', NULL),
(25, 'crm_contact_legal_entities', 10, 2, 9, 'Prosa Produções', 'prosadrive@gmail.com', '[]', '[{\"number\":\"(62) 99908-8067\",\"name\":null}]', NULL, '1', NULL, '2025-08-22 20:57:57', '2025-08-22 20:57:57', NULL),
(26, 'crm_contact_individuals', 16, 2, 9, 'Yan Guilherme', 'yanguilherme787@hotmail.com', '[]', '[{\"number\":\"(62) 98144-0525\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 21:00:31', '2025-08-22 21:00:31', NULL),
(27, 'crm_contact_individuals', 17, 2, 9, 'Paulo Victor Zanella Tavares', 'pvsktrock@gmail.com', NULL, '[{\"name\":null,\"number\":\"(62) 99138-8707\"}]', NULL, '1', NULL, '2025-08-22 21:50:29', '2025-08-22 21:50:29', NULL),
(28, 'crm_contact_legal_entities', 11, 2, 9, 'Estrutural Pisos e Vidros', 'contato@estruturalpisosevidros.com.br', NULL, '[{\"name\":null,\"number\":\"(31) 97599-3678\"}]', NULL, '1', NULL, '2025-08-22 22:08:37', '2025-08-22 22:08:37', NULL),
(29, 'crm_contact_individuals', 18, 2, 9, 'Márcio Franco', NULL, '[]', '[{\"number\":\"(31) 97599-3678\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 22:08:49', '2025-08-22 22:08:49', NULL),
(30, 'crm_contact_individuals', 19, 2, NULL, 'Pedro Henrique Felix Frazão', NULL, '[]', '[{\"number\":\"(62) 98213-3373\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-22 22:18:42', '2025-08-22 22:18:42', NULL),
(31, 'crm_contact_legal_entities', 12, 1, 9, 'Nobis Arquitetura', NULL, NULL, '[{\"name\":null,\"number\":null}]', NULL, '1', NULL, '2025-08-25 18:21:35', '2025-08-25 18:21:35', NULL),
(32, 'crm_contact_individuals', 20, 1, 9, 'Renata Diniz', NULL, '[]', '[{\"number\":\"(31) 98817-2539\",\"name\":\"Whatsapp\"}]', NULL, '1', NULL, '2025-08-25 18:22:14', '2025-08-25 18:22:14', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_contact_crm_contact_role`
--

CREATE TABLE `crm_contact_crm_contact_role` (
  `contact_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_contact_crm_contact_role`
--

INSERT INTO `crm_contact_crm_contact_role` (`contact_id`, `role_id`) VALUES
(1, 1),
(1, 3),
(2, 1),
(2, 3),
(3, 1),
(3, 3),
(4, 1),
(4, 3),
(5, 1),
(5, 3),
(6, 1),
(6, 3),
(7, 1),
(7, 3),
(8, 1),
(8, 3),
(9, 1),
(9, 3),
(10, 1),
(10, 3),
(11, 1),
(11, 3),
(12, 1),
(12, 3),
(13, 1),
(13, 3),
(14, 1),
(14, 3),
(15, 1),
(15, 3),
(16, 1),
(16, 3),
(17, 1),
(17, 3),
(18, 1),
(18, 3),
(19, 1),
(19, 3),
(20, 1),
(20, 3),
(21, 1),
(21, 3),
(22, 1),
(22, 3),
(23, 1),
(23, 3),
(24, 1),
(24, 3),
(25, 1),
(25, 3),
(26, 1),
(26, 3),
(27, 1),
(27, 3),
(28, 1),
(28, 3),
(29, 1),
(29, 3),
(30, 4),
(31, 1),
(31, 3),
(32, 1),
(32, 3);

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_contact_individuals`
--

CREATE TABLE `crm_contact_individuals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cpf` varchar(255) DEFAULT NULL,
  `rg` varchar(255) DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `occupation` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_contact_individuals`
--

INSERT INTO `crm_contact_individuals` (`id`, `cpf`, `rg`, `gender`, `birth_date`, `occupation`, `deleted_at`) VALUES
(1, NULL, NULL, 'M', NULL, 'Sócio/Dono', NULL),
(2, '053.505.711-33', NULL, 'M', '1994-04-06', 'Autônomo', NULL),
(3, NULL, NULL, 'F', NULL, 'Sócio/Dono', NULL),
(4, '031.338.461-40', NULL, 'M', '1991-03-17', 'Sócio/Dono', NULL),
(5, '027.917.101-32', NULL, 'F', '1989-01-25', 'Autônomo', NULL),
(6, NULL, NULL, 'F', NULL, 'Sócio/Dono', NULL),
(7, NULL, NULL, 'M', NULL, 'Sócio/Dono', NULL),
(8, NULL, NULL, 'M', NULL, 'Autônomo', NULL),
(9, NULL, NULL, NULL, NULL, NULL, NULL),
(10, NULL, NULL, 'M', NULL, 'TI', NULL),
(11, NULL, NULL, 'M', NULL, 'Sócio/Dono', NULL),
(12, NULL, NULL, 'M', NULL, 'Autônomo', NULL),
(13, NULL, NULL, 'M', NULL, 'Autônomo', NULL),
(14, NULL, NULL, NULL, NULL, NULL, NULL),
(15, NULL, NULL, NULL, NULL, NULL, NULL),
(16, NULL, NULL, 'M', NULL, 'Autônomo', NULL),
(17, NULL, NULL, NULL, NULL, NULL, NULL),
(18, NULL, NULL, 'M', NULL, 'Autônomo', NULL),
(19, NULL, NULL, 'M', NULL, 'Autônomo', NULL),
(20, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_contact_individual_crm_contact_legal_entity`
--

CREATE TABLE `crm_contact_individual_crm_contact_legal_entity` (
  `individual_id` bigint(20) UNSIGNED NOT NULL,
  `legal_entity_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_contact_individual_crm_contact_legal_entity`
--

INSERT INTO `crm_contact_individual_crm_contact_legal_entity` (`individual_id`, `legal_entity_id`) VALUES
(1, 1),
(3, 2),
(4, 3),
(7, 4),
(8, 5),
(9, 6),
(10, 7),
(11, 8),
(14, 9),
(15, 10),
(18, 11),
(20, 12);

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_contact_legal_entities`
--

CREATE TABLE `crm_contact_legal_entities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `trade_name` varchar(255) DEFAULT NULL,
  `cnpj` varchar(255) DEFAULT NULL,
  `municipal_registration` varchar(255) DEFAULT NULL,
  `state_registration` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `sector` varchar(255) DEFAULT NULL,
  `num_employees` varchar(255) DEFAULT NULL,
  `monthly_income` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_contact_legal_entities`
--

INSERT INTO `crm_contact_legal_entities` (`id`, `trade_name`, `cnpj`, `municipal_registration`, `state_registration`, `url`, `sector`, `num_employees`, `monthly_income`, `deleted_at`) VALUES
(1, NULL, '17.000.259/0001-35', NULL, NULL, 'https://consulteng.eng.br', 'Serviços', NULL, NULL, NULL),
(2, NULL, NULL, NULL, NULL, 'https://duarteimoveis.imb.br', 'Comércio', NULL, NULL, NULL),
(3, NULL, NULL, NULL, NULL, 'https://imobiliariaconflar.com.br/', 'Comércio', NULL, NULL, NULL),
(4, NULL, '28.069.828/0001-15', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, NULL, NULL, NULL, NULL, 'https://exho.com.br', 'Comércio', NULL, NULL, NULL),
(7, NULL, '16.800.114/0001-56', NULL, NULL, 'https://flexcentroempresarial.com.br/', NULL, NULL, NULL, NULL),
(8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(9, NULL, '43.179.744/0001-28', NULL, NULL, 'https://oftalmojamous.com.br/', 'Serviços', NULL, NULL, NULL),
(10, NULL, '38.098.830/0001-76', NULL, NULL, 'https://prosaproducoes.com.br/', 'Serviços', NULL, NULL, NULL),
(11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, NULL, '55.535.743/0001-58', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_contact_roles`
--

CREATE TABLE `crm_contact_roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_contact_roles`
--

INSERT INTO `crm_contact_roles` (`id`, `name`, `slug`, `description`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Assinante', 'assinante', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(2, 'Lead', 'lead', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(3, 'Cliente', 'cliente', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(4, 'Fornecedor', 'fornecedor', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(5, 'Outro', 'outro', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_funnels`
--

CREATE TABLE `crm_funnels` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `order` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `status` char(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_funnels`
--

INSERT INTO `crm_funnels` (`id`, `name`, `slug`, `description`, `order`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Funil de Vendas Padrão', 'funil-de-vendas-padrao', 'Funil padrão de vendas B2B com ciclo médio de 4–8 semanas.', 1, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(2, 'Funil de Ganhos Rápidos', 'funil-de-ganhos-rapidos', 'Funil curto, ideal para vendas simples ou upgrades rápidos.', 2, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(3, 'Funil de Renovação e Upsell', 'funil-de-renovacao-e-upsell', 'Para renovações de contratos ou ofertas de cross-sell.', 3, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_funnel_stages`
--

CREATE TABLE `crm_funnel_stages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `funnel_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `business_probability` int(11) DEFAULT NULL,
  `order` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_funnel_stages`
--

INSERT INTO `crm_funnel_stages` (`id`, `funnel_id`, `name`, `slug`, `description`, `business_probability`, `order`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Prospecção', 'prospeccao', NULL, 10, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(2, 1, 'Qualificação', 'qualificacao', NULL, 30, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(3, 1, 'Proposta', 'proposta', NULL, 50, 3, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(4, 1, 'Negociação', 'negociacao', NULL, 80, 4, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(5, 1, 'Negócio Fechado – Ganhou', 'negocio-fechado-ganhou', NULL, 100, 5, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(6, 1, 'Negócio Perdido', 'negocio-perdido', NULL, 0, 6, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(7, 2, 'Novo', 'novo', NULL, 10, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(8, 2, 'Contatado', 'contatado', NULL, 30, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(9, 2, 'Demonstração / Proposta', 'demonstracao-proposta', NULL, 60, 3, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(10, 2, 'Decisão', 'decisao', NULL, 90, 4, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(11, 2, 'Negócio Fechado – Ganhou', 'negocio-fechado-ganhou-2', NULL, 100, 5, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(12, 2, 'Negócio Perdido', 'negocio-perdido-2', NULL, 0, 6, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(13, 3, 'Lembrete de Renovação Enviado', 'lembrete-de-renovacao-enviado', NULL, 20, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(14, 3, 'Negociação (Renovação/Upsell)', 'negociacao-renovacao-upsell', NULL, 50, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(15, 3, 'Aprovado pelo Cliente', 'aprovado-pelo-cliente', NULL, 80, 3, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(16, 3, 'Renovado / Upsell', 'renovado-upsell', NULL, 100, 4, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(17, 3, 'Churn', 'churn', NULL, 0, 5, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_funnel_substages`
--

CREATE TABLE `crm_funnel_substages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `funnel_stage_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `order` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_funnel_substages`
--

INSERT INTO `crm_funnel_substages` (`id`, `funnel_stage_id`, `name`, `slug`, `description`, `order`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Aguardando Atendimento', 'aguardando-atendimento', NULL, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(2, 1, 'Tentando Contato', 'tentando-contato', NULL, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(3, 1, 'Contato Realizado', 'contato-realizado', NULL, 3, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(4, 1, 'Descarte Temporário', 'descarte-temporario', NULL, 4, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(5, 2, 'Necessidades Levantadas', 'necessidades-levantadas', NULL, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(6, 2, 'Orçamento Confirmado', 'orcamento-confirmado', NULL, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(7, 3, 'Proposta Elaborada', 'proposta-elaborada', NULL, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(8, 3, 'Proposta Enviada', 'proposta-enviada', NULL, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(9, 4, 'Tratativa de Objeções', 'tratativa-de-objecoes', NULL, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(10, 4, 'Revisão de Contrato', 'revisao-de-contrato', NULL, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(11, 9, 'Demonstração Agendada', 'demonstracao-agendada', NULL, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(12, 9, 'Proposta Enviada', 'proposta-enviada-2', NULL, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(13, 13, 'Notificação por E-mail ou WhatsApp', 'notificacao-por-e-mail-ou-whatsapp', NULL, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(14, 13, 'Chamada de Follow-up', 'chamada-de-follow-up', NULL, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(15, 14, 'Apresentação de Opções', 'apresentacao-de-opcoes', NULL, 1, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(16, 14, 'Ajuste de Termos', 'ajuste-de-termos', NULL, 2, '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `crm_sources`
--

CREATE TABLE `crm_sources` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `crm_sources`
--

INSERT INTO `crm_sources` (`id`, `name`, `slug`, `description`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Website', 'website', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(2, 'Meta Ads', 'meta-ads', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(3, 'Google Ads', 'google-ads', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(4, 'Tráfego direto', 'trafego-direto', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(5, 'Pesquisa orgânica', 'pesquisa-organica', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(6, 'Pesquisa paga', 'pesquisa-paga', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(7, 'Email marketing', 'email-marketing', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(8, 'Mídia social', 'midia-social', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(9, 'Referências', 'referencias', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(10, 'Fontes offline', 'fontes-offline', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(11, 'Outras campanhas', 'outras-campanhas', NULL, '1', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `financial_bank_accounts`
--

CREATE TABLE `financial_bank_accounts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `bank_institution_id` bigint(20) UNSIGNED DEFAULT NULL,
  `agency_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role` char(1) NOT NULL DEFAULT '1',
  `type_person` char(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `is_main` tinyint(1) NOT NULL DEFAULT 0,
  `balance_date` timestamp NOT NULL DEFAULT '2025-08-22 19:19:22',
  `balance` bigint(20) NOT NULL DEFAULT 0,
  `complement` text DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `financial_bank_accounts`
--

INSERT INTO `financial_bank_accounts` (`id`, `bank_institution_id`, `agency_id`, `role`, `type_person`, `name`, `is_main`, `balance_date`, `balance`, `complement`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 184, NULL, '1', '2', 'Nu Conta => VCL', 1, '2025-08-22 03:00:00', 0, NULL, '1', '2025-08-22 19:42:34', '2025-08-22 19:43:54', NULL),
(2, 233, 1, '1', '1', '[CORA] InC Sistemas', 0, '2025-08-22 03:00:00', 0, NULL, '1', '2025-08-22 19:43:35', '2025-08-22 19:43:35', NULL),
(3, 233, 2, '1', '1', '[CORA] InC Digital', 0, '2025-08-22 03:00:00', 0, NULL, '1', '2025-08-22 19:44:29', '2025-08-22 19:44:29', NULL),
(4, 233, 3, '1', '1', '[CORA] I2C Lares', 0, '2025-08-22 03:00:00', 0, NULL, '1', '2025-08-22 19:44:56', '2025-08-22 19:44:56', NULL),
(5, 233, 4, '1', '1', '[CORA] I2C Koba', 0, '2025-08-22 03:00:00', 0, NULL, '1', '2025-08-22 19:45:21', '2025-08-22 19:45:21', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `financial_bank_institutions`
--

CREATE TABLE `financial_bank_institutions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` int(11) DEFAULT NULL,
  `ispb` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `short_name` varchar(255) DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `financial_bank_institutions`
--

INSERT INTO `financial_bank_institutions` (`id`, `code`, `ispb`, `name`, `short_name`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '00000000', 'Banco do Brasil S.A.', 'BCO DO BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(2, 70, '00000208', 'BRB - BANCO DE BRASILIA S.A.', 'BRB - BCO DE BRASILIA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(3, NULL, '60934221', 'Câmara de Câmbio B3', 'Câmbio B3', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(4, 539, '00122327', 'SANTINVEST S.A. - CREDITO, FINANCIAMENTO E INVESTIMENTOS', 'SANTINVEST S.A. - CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(5, 430, '00204963', 'COOPERATIVA DE CREDITO RURAL SEARA - CREDISEARA', 'CCR SEARA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(6, 272, '00250699', 'AGK CORRETORA DE CAMBIO S.A.', 'AGK CC S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(7, 136, '00315557', 'CONFEDERAÇÃO NACIONAL DAS COOPERATIVAS CENTRAIS UNICRED LTDA. - UNICRED DO BRASI', 'CONF NAC COOP CENTRAIS UNICRED', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(8, 407, '00329598', 'ÍNDIGO INVESTIMENTOS DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'ÍNDIGO INVESTIMENTOS DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(9, 104, '00360305', 'CAIXA ECONOMICA FEDERAL', 'CAIXA ECONOMICA FEDERAL', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(10, 77, '00416968', 'Banco Inter S.A.', 'BANCO INTER', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(11, 423, '00460065', 'COLUNA S/A DISTRIBUIDORA DE TITULOS E VALORES MOBILIÁRIOS', 'COLUNA S.A. DTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(12, 741, '00517645', 'BANCO RIBEIRAO PRETO S.A.', 'BCO RIBEIRAO PRETO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(13, 330, '00556603', 'BANCO BARI DE INVESTIMENTOS E FINANCIAMENTOS S.A.', 'BANCO BARI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(14, 739, '00558456', 'Banco Cetelem S.A.', 'BCO CETELEM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(15, 534, '00714671', 'EWALLY INSTITUIÇÃO DE PAGAMENTO S.A.', 'EWALLY IP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(16, 743, '00795423', 'Banco Semear S.A.', 'BANCO SEMEAR', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(17, 100, '00806535', 'Planner Corretora de Valores S.A.', 'PLANNER CV S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(18, 541, '00954288', 'FUNDO GARANTIDOR DE CREDITOS - FGC', 'FDO GARANTIDOR CRÉDITOS', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(19, 96, '00997185', 'Banco B3 S.A.', 'BCO B3 S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(20, 747, '01023570', 'Banco Rabobank International Brasil S.A.', 'BCO RABOBANK INTL BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(21, 362, '01027058', 'CIELO S.A. - INSTITUIÇÃO DE PAGAMENTO', 'CIELO IP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(22, 322, '01073966', 'Cooperativa de Crédito Rural de Abelardo Luz - Sulcredi/Crediluz', 'CCR DE ABELARDO LUZ', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(23, 748, '01181521', 'BANCO COOPERATIVO SICREDI S.A.', 'BCO COOPERATIVO SICREDI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(24, 350, '01330387', 'COOPERATIVA DE CRÉDITO RURAL DE PEQUENOS AGRICULTORES E DA REFORMA AGRÁRIA DO CE', 'CREHNOR LARANJEIRAS', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(25, 752, '01522368', 'Banco BNP Paribas Brasil S.A.', 'BCO BNP PARIBAS BRASIL S A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(26, 379, '01658426', 'COOPERFORTE - COOPERATIVA DE ECONOMIA E CRÉDITO MÚTUO DE FUNCIONÁRIOS DE INSTITU', 'CECM COOPERFORTE', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(27, 399, '01701201', 'Kirton Bank S.A. - Banco Múltiplo', 'KIRTON BANK', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(28, 378, '01852137', 'BANCO BRASILEIRO DE CRÉDITO SOCIEDADE ANÔNIMA', 'BCO BRASILEIRO DE CRÉDITO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(29, 413, '01858774', 'BANCO BV S.A.', 'BCO BV S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(30, 756, '02038232', 'BANCO COOPERATIVO SICOOB S.A. - BANCO SICOOB', 'BANCO SICOOB S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(31, 360, '02276653', 'TRINUS CAPITAL DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'TRINUS CAPITAL DTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(32, 757, '02318507', 'BANCO KEB HANA DO BRASIL S.A.', 'BCO KEB HANA DO BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(33, 102, '02332886', 'XP INVESTIMENTOS CORRETORA DE CÂMBIO,TÍTULOS E VALORES MOBILIÁRIOS S/A', 'XP INVESTIMENTOS CCTVM S/A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(34, 84, '02398976', 'SISPRIME DO BRASIL - COOPERATIVA DE CRÉDITO', 'SISPRIME DO BRASIL - COOP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(35, 180, '02685483', 'CM CAPITAL MARKETS CORRETORA DE CÂMBIO, TÍTULOS E VALORES MOBILIÁRIOS LTDA', 'CM CAPITAL MARKETS CCTVM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(36, 66, '02801938', 'BANCO MORGAN STANLEY S.A.', 'BCO MORGAN STANLEY S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(37, 15, '02819125', 'UBS Brasil Corretora de Câmbio, Títulos e Valores Mobiliários S.A.', 'UBS BRASIL CCTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(38, 143, '02992317', 'Treviso Corretora de Câmbio S.A.', 'TREVISO CC S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(39, 62, '03012230', 'Hipercard Banco Múltiplo S.A.', 'HIPERCARD BM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(40, 74, '03017677', 'Banco J. Safra S.A.', 'BCO. J.SAFRA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(41, 99, '03046391', 'UNIPRIME CENTRAL NACIONAL - CENTRAL NACIONAL DE COOPERATIVA DE CREDITO', 'UNIPRIME COOPCENTRAL LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(42, 387, '03215790', 'Banco Toyota do Brasil S.A.', 'BCO TOYOTA DO BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(43, 326, '03311443', 'PARATI - CREDITO, FINANCIAMENTO E INVESTIMENTO S.A.', 'PARATI - CFI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(44, 25, '03323840', 'Banco Alfa S.A.', 'BCO ALFA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(45, 75, '03532415', 'Banco ABN Amro S.A.', 'BCO ABN AMRO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(46, 40, '03609817', 'Banco Cargill S.A.', 'BCO CARGILL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(47, 307, '03751794', 'Terra Investimentos Distribuidora de Títulos e Valores Mobiliários Ltda.', 'TERRA INVESTIMENTOS DTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(48, 385, '03844699', 'COOPERATIVA DE ECONOMIA E CREDITO MUTUO DOS TRABALHADORES PORTUARIOS DA GRANDE V', 'CECM DOS TRAB.PORT. DA G.VITOR', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(49, 425, '03881423', 'SOCINAL S.A. - CRÉDITO, FINANCIAMENTO E INVESTIMENTO', 'SOCINAL S.A. CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(50, 190, '03973814', 'SERVICOOP - COOPERATIVA DE CRÉDITO DOS SERVIDORES PÚBLICOS ESTADUAIS E MUNICIPAI', 'SERVICOOP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(51, 296, '04062902', 'OZ CORRETORA DE CÂMBIO S.A.', 'OZ CORRETORA DE CÂMBIO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(52, 63, '04184779', 'Banco Bradescard S.A.', 'BANCO BRADESCARD', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(53, 191, '04257795', 'Nova Futura Corretora de Títulos e Valores Mobiliários Ltda.', 'NOVA FUTURA CTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(54, 382, '04307598', 'FIDÚCIA SOCIEDADE DE CRÉDITO AO MICROEMPREENDEDOR E À EMPRESA DE PEQUENO PORTE L', 'FIDUCIA SCMEPP LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(55, 64, '04332281', 'GOLDMAN SACHS DO BRASIL BANCO MULTIPLO S.A.', 'GOLDMAN SACHS DO BRASIL BM S.A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(56, 459, '04546162', 'COOPERATIVA DE CRÉDITO MÚTUO DE SERVIDORES PÚBLICOS DO ESTADO DE SÃO PAULO - CRE', 'CCM SERV. PÚBLICOS SP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(57, 97, '04632856', 'Credisis - Central de Cooperativas de Crédito Ltda.', 'CREDISIS CENTRAL DE COOPERATIVAS DE CRÉDITO LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(58, 16, '04715685', 'COOPERATIVA DE CRÉDITO MÚTUO DOS DESPACHANTES DE TRÂNSITO DE SANTA CATARINA E RI', 'CCM DESP TRÂNS SC E RS', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(59, 299, '04814563', 'BANCO AFINZ S.A. - BANCO MÚLTIPLO', 'BCO AFINZ S.A. - BM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(60, 471, '04831810', 'COOPERATIVA DE ECONOMIA E CREDITO MUTUO DOS SERVIDORES PUBLICOS DE PINHÃO - CRES', 'CECM SERV PUBL PINHÃO', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(61, 468, '04862600', 'PORTOSEG S.A. - CREDITO, FINANCIAMENTO E INVESTIMENTO', 'PORTOSEG S.A. CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(62, 12, '04866275', 'Banco Inbursa S.A.', 'BANCO INBURSA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(63, 3, '04902979', 'BANCO DA AMAZONIA S.A.', 'BCO DA AMAZONIA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(64, 60, '04913129', 'Confidence Corretora de Câmbio S.A.', 'CONFIDENCE CC S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(65, 37, '04913711', 'Banco do Estado do Pará S.A.', 'BCO DO EST. DO PA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(66, 411, '05192316', 'Via Certa Financiadora S.A. - Crédito, Financiamento e Investimentos', 'VIA CERTA FINANCIADORA S.A. - CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(67, 359, '05351887', 'ZEMA CRÉDITO, FINANCIAMENTO E INVESTIMENTO S/A', 'ZEMA CFI S/A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(68, 159, '05442029', 'Casa do Crédito S.A. Sociedade de Crédito ao Microempreendedor', 'CASA CREDITO S.A. SCM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(69, 85, '05463212', 'Cooperativa Central de Crédito - Ailos', 'COOPCENTRAL AILOS', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(70, 400, '05491616', 'COOPERATIVA DE CRÉDITO, POUPANÇA E SERVIÇOS FINANCEIROS DO CENTRO OESTE - CREDIT', 'COOP CREDITAG', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(71, 429, '05676026', 'Crediare S.A. - Crédito, financiamento e investimento', 'CREDIARE CFI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(72, 410, '05684234', 'PLANNER SOCIEDADE DE CRÉDITO DIRETO S.A.', 'PLANNER SOCIEDADE DE CRÉDITO DIRETO', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(73, 114, '05790149', 'Central Cooperativa de Crédito no Estado do Espírito Santo - CECOOP', 'CENTRAL COOPERATIVA DE CRÉDITO NO ESTADO DO ESPÍRITO SANTO', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(74, 328, '05841967', 'COOPERATIVA DE ECONOMIA E CRÉDITO MÚTUO DOS FABRICANTES DE CALÇADOS DE SAPIRANGA', 'CECM FABRIC CALÇADOS SAPIRANGA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(75, 36, '06271464', 'Banco Bradesco BBI S.A.', 'BCO BBI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(76, 469, '07138049', 'LIGA INVEST DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA', 'LIGA INVEST DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(77, 394, '07207996', 'Banco Bradesco Financiamentos S.A.', 'BCO BRADESCO FINANC. S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(78, 4, '07237373', 'Banco do Nordeste do Brasil S.A.', 'BCO DO NORDESTE DO BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(79, 458, '07253654', 'HEDGE INVESTMENTS DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'HEDGE INVESTMENTS DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(80, 320, '07450604', 'China Construction Bank (Brasil) Banco Múltiplo S/A', 'BCO CCB BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(81, 189, '07512441', 'HS FINANCEIRA S/A CREDITO, FINANCIAMENTO E INVESTIMENTOS', 'HS FINANCEIRA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(82, 105, '07652226', 'Lecca Crédito, Financiamento e Investimento S/A', 'LECCA CFI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(83, 76, '07656500', 'Banco KDB do Brasil S.A.', 'BCO KDB BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(84, 82, '07679404', 'BANCO TOPÁZIO S.A.', 'BANCO TOPÁZIO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(85, 312, '07693858', 'HSCM - SOCIEDADE DE CRÉDITO AO MICROEMPREENDEDOR E À EMPRESA DE PEQUENO PORTE LT', 'HSCM SCMEPP LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(86, 195, '07799277', 'VALOR SOCIEDADE DE CRÉDITO DIRETO S.A.', 'VALOR SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(87, 93, '07945233', 'PÓLOCRED   SOCIEDADE DE CRÉDITO AO MICROEMPREENDEDOR E À EMPRESA DE PEQUENO PORT', 'POLOCRED SCMEPP LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(88, 391, '08240446', 'COOPERATIVA DE CREDITO RURAL DE IBIAM - SULCREDI/IBIAM', 'CCR DE IBIAM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(89, 273, '08253539', 'Cooperativa de Crédito Rural de São Miguel do Oeste - Sulcredi/São Miguel', 'CCR DE SÃO MIGUEL DO OESTE', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(90, 368, '08357240', 'Banco CSF S.A.', 'BCO CSF S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(91, 290, '08561701', 'PAGSEGURO INTERNET INSTITUIÇÃO DE PAGAMENTO S.A.', 'PAGSEGURO INTERNET IP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(92, 259, '08609934', 'MONEYCORP BANCO DE CÂMBIO S.A.', 'MONEYCORP BCO DE CÂMBIO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(93, 395, '08673569', 'F.D\'GOLD - DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'F D GOLD DTVM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(94, 364, '09089356', 'EFÍ S.A. - INSTITUIÇÃO DE PAGAMENTO', 'EFÍ S.A. - IP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(95, 157, '09105360', 'ICAP do Brasil Corretora de Títulos e Valores Mobiliários Ltda.', 'ICAP DO BRASIL CTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(96, 183, '09210106', 'SOCRED S.A. - SOCIEDADE DE CRÉDITO AO MICROEMPREENDEDOR E À EMPRESA DE PEQUENO P', 'SOCRED SA - SCMEPP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(97, 14, '09274232', 'STATE STREET BRASIL S.A. - BANCO COMERCIAL', 'STATE STREET BR S.A. BCO COMERCIAL', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(98, 130, '09313766', 'CARUANA S.A. - SOCIEDADE DE CRÉDITO, FINANCIAMENTO E INVESTIMENTO', 'CARUANA SCFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(99, 358, '09464032', 'MIDWAY S.A. - CRÉDITO, FINANCIAMENTO E INVESTIMENTO', 'MIDWAY S.A. - SCFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(100, 127, '09512542', 'Codepe Corretora de Valores e Câmbio S.A.', 'CODEPE CVC S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(101, 79, '09516419', 'PICPAY BANK - BANCO MÚLTIPLO S.A', 'PICPAY BANK - BANCO MÚLTIPLO S.A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(102, 141, '09526594', 'BANCO MASTER DE INVESTIMENTO S.A.', 'MASTER BI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(103, 340, '09554480', 'SUPERDIGITAL INSTITUIÇÃO DE PAGAMENTO S.A.', 'SUPERDIGITAL I.P. S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(104, 81, '10264663', 'BancoSeguro S.A.', 'BANCOSEGURO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(105, 475, '10371492', 'Banco Yamaha Motor do Brasil S.A.', 'BCO YAMAHA MOTOR S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(106, 133, '10398952', 'CONFEDERAÇÃO NACIONAL DAS COOPERATIVAS CENTRAIS DE CRÉDITO E ECONOMIA FAMILIAR E', 'CRESOL CONFEDERAÇÃO', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(107, 323, '10573521', 'MERCADO PAGO INSTITUIÇÃO DE PAGAMENTO LTDA.', 'MERCADO PAGO IP LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(108, 121, '10664513', 'Banco Agibank S.A.', 'BCO AGIBANK S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(109, 83, '10690848', 'Banco da China Brasil S.A.', 'BCO DA CHINA BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(110, 138, '10853017', 'Get Money Corretora de Câmbio S.A.', 'GET MONEY CC LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(111, 24, '10866788', 'Banco Bandepe S.A.', 'BCO BANDEPE S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(112, 384, '11165756', 'GLOBAL FINANÇAS SOCIEDADE DE CRÉDITO AO MICROEMPREENDEDOR E À EMPRESA DE PEQUENO', 'GLOBAL SCM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(113, 426, '11285104', 'NEON FINANCEIRA - CRÉDITO, FINANCIAMENTO E INVESTIMENTO S.A.', 'NEON FINANCEIRA - CFI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(114, 88, '11476673', 'BANCO RANDON S.A.', 'BANCO RANDON S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(115, 319, '11495073', 'OM DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA', 'OM DTVM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(116, 274, '11581339', 'BMP SOCIEDADE DE CRÉDITO AO MICROEMPREENDEDOR E A EMPRESA DE PEQUENO PORTE LTDA.', 'BMP SCMEPP LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(117, 95, '11703662', 'Travelex Banco de Câmbio S.A.', 'TRAVELEX BANCO DE CÂMBIO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(118, 94, '11758741', 'Banco Finaxis S.A.', 'BANCO FINAXIS', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(119, 478, '11760553', 'GAZINCRED S.A. SOCIEDADE DE CRÉDITO, FINANCIAMENTO E INVESTIMENTO', 'GAZINCRED S.A. SCFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(120, 276, '11970623', 'BANCO SENFF S.A.', 'BCO SENFF S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(121, 447, '12392983', 'MIRAE ASSET WEALTH MANAGEMENT (BRAZIL) CORRETORA DE CÂMBIO, TÍTULOS E VALORES MO', 'MIRAE ASSET CCTVM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(122, 47, '13009717', 'Banco do Estado de Sergipe S.A.', 'BCO DO EST. DE SE S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(123, 144, '13059145', 'BEXS BANCO DE CÂMBIO S/A', 'BEXS BCO DE CAMBIO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(124, 332, '13140088', 'ACESSO SOLUÇÕES DE PAGAMENTO S.A. - INSTITUIÇÃO DE PAGAMENTO', 'ACESSO SOLUÇÕES DE PAGAMENTO S.A. - INSTITUIÇÃO DE PAGAMENTO', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(125, 450, '13203354', 'FITBANK INSTITUIÇÃO DE PAGAMENTOS ELETRÔNICOS S.A.', 'FITBANK IP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(126, 126, '13220493', 'BR Partners Banco de Investimento S.A.', 'BR PARTNERS BI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(127, 325, '13293225', 'Órama Distribuidora de Títulos e Valores Mobiliários S.A.', 'ÓRAMA DTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(128, 301, '13370835', 'DOCK INSTITUIÇÃO DE PAGAMENTO S.A.', 'DOCK IP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(129, 173, '13486793', 'BRL Trust Distribuidora de Títulos e Valores Mobiliários S.A.', 'BRL TRUST DTVM SA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(130, 331, '13673855', 'Fram Capital Distribuidora de Títulos e Valores Mobiliários S.A.', 'FRAM CAPITAL DTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(131, 119, '13720915', 'Banco Western Union do Brasil S.A.', 'BCO WESTERN UNION', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(132, 396, '13884775', 'HUB INSTITUIÇÃO DE PAGAMENTO S.A.', 'HUB IP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(133, 509, '13935893', 'CELCOIN INSTITUICAO DE PAGAMENTO S.A.', 'CELCOIN IP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(134, 309, '14190547', 'CAMBIONET CORRETORA DE CÂMBIO LTDA.', 'CAMBIONET CC LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(135, 254, '14388334', 'PARANÁ BANCO S.A.', 'PARANA BCO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(136, 268, '14511781', 'BARI COMPANHIA HIPOTECÁRIA', 'BARI CIA HIPOTECÁRIA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(137, 401, '15111975', 'IUGU INSTITUIÇÃO DE PAGAMENTO S.A.', 'IUGU IP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(138, 107, '15114366', 'Banco Bocom BBM S.A.', 'BCO BOCOM BBM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(139, 334, '15124464', 'BANCO BESA S.A.', 'BANCO BESA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(140, 412, '15173776', 'SOCIAL BANK BANCO MÚLTIPLO S/A', 'SOCIAL BANK S/A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(141, 124, '15357060', 'Banco Woori Bank do Brasil S.A.', 'BCO WOORI BANK DO BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(142, 149, '15581638', 'Facta Financeira S.A. - Crédito Financiamento e Investimento', 'FACTA S.A. CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(143, 197, '16501555', 'STONE INSTITUIÇÃO DE PAGAMENTO S.A.', 'STONE IP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(144, 439, '16695922', 'ID CORRETORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'ID CTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(145, 313, '16927221', 'AMAZÔNIA CORRETORA DE CÂMBIO LTDA.', 'AMAZÔNIA CC LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(146, 142, '16944141', 'Broker Brasil Corretora de Câmbio Ltda.', 'BROKER BRASIL CC LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(147, 529, '17079937', 'PINBANK BRASIL INSTITUIÇÃO DE PAGAMENTO S.A.', 'PINBANK IP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(148, 389, '17184037', 'Banco Mercantil do Brasil S.A.', 'BCO MERCANTIL DO BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(149, 184, '17298092', 'Banco Itaú BBA S.A.', 'BCO ITAÚ BBA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(150, 634, '17351180', 'BANCO TRIANGULO S.A.', 'BCO TRIANGULO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(151, 545, '17352220', 'SENSO CORRETORA DE CAMBIO E VALORES MOBILIARIOS S.A', 'SENSO CCVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(152, 132, '17453575', 'ICBC do Brasil Banco Múltiplo S.A.', 'ICBC DO BRASIL BM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(153, 298, '17772370', 'Vip\'s Corretora de Câmbio Ltda.', 'VIPS CC LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(154, 377, '17826860', 'BMS SOCIEDADE DE CRÉDITO DIRETO S.A.', 'BMS SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(155, 321, '18188384', 'CREFAZ SOCIEDADE DE CRÉDITO AO MICROEMPREENDEDOR E A EMPRESA DE PEQUENO PORTE LT', 'CREFAZ SCMEPP LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(156, 260, '18236120', 'NU PAGAMENTOS S.A. - INSTITUIÇÃO DE PAGAMENTO', 'NU PAGAMENTOS - IP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(157, 470, '18394228', 'CDC SOCIEDADE DE CRÉDITO DIRETO S.A.', 'CDC SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(158, 129, '18520834', 'UBS Brasil Banco de Investimento S.A.', 'UBS BRASIL BI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(159, 128, '19307785', 'BRAZA BANK S.A. BANCO DE CÂMBIO', 'BRAZA BANK S.A. BCO DE CÂMBIO', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(160, 416, '19324634', 'LAMARA SOCIEDADE DE CRÉDITO DIRETO S.A.', 'LAMARA SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(161, 461, '19540550', 'ASAAS GESTÃO FINANCEIRA INSTITUIÇÃO DE PAGAMENTO S.A.', 'ASAAS IP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(162, 194, '20155248', 'PARMETAL DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA', 'PARMETAL DTVM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(163, 536, '20855875', 'NEON PAGAMENTOS S.A. - INSTITUIÇÃO DE PAGAMENTO', 'NEON PAGAMENTOS S.A. IP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(164, 383, '21018182', 'EBANX INSTITUICAO DE PAGAMENTOS LTDA.', 'EBANX IP LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(165, 324, '21332862', 'CARTOS SOCIEDADE DE CRÉDITO DIRETO S.A.', 'CARTOS SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(166, 310, '22610500', 'VORTX DISTRIBUIDORA DE TITULOS E VALORES MOBILIARIOS LTDA.', 'VORTX DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(167, 380, '22896431', 'PICPAY INSTITUIçãO DE PAGAMENTO S.A.', 'PICPAY', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(168, 280, '23862762', 'WILL FINANCEIRA S.A. CRÉDITO, FINANCIAMENTO E INVESTIMENTO', 'WILL FINANCEIRA S.A.CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(169, 146, '24074692', 'GUITTA CORRETORA DE CAMBIO LTDA.', 'GUITTA CC LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(170, 343, '24537861', 'FFA SOCIEDADE DE CRÉDITO AO MICROEMPREENDEDOR E À EMPRESA DE PEQUENO PORTE LTDA.', 'FFA SCMEPP LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(171, 279, '26563270', 'PRIMACREDI COOPERATIVA DE CRÉDITO DE PRIMAVERA DO LESTE', 'COOP DE PRIMAVERA DO LESTE', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(172, 335, '27098060', 'Banco Digio S.A.', 'BANCO DIGIO', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(173, 349, '27214112', 'AL5 S.A. CRÉDITO, FINANCIAMENTO E INVESTIMENTO', 'AL5 S.A. CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(174, 427, '27302181', 'COOPERATIVA DE CREDITO DOS SERVIDORES DA UNIVERSIDADE FEDERAL DO ESPIRITO SANTO', 'CRED-UFES', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(175, 374, '27351731', 'REALIZE CRÉDITO, FINANCIAMENTO E INVESTIMENTO S.A.', 'REALIZE CFI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(176, 278, '27652684', 'Genial Investimentos Corretora de Valores Mobiliários S.A.', 'GENIAL INVESTIMENTOS CVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(177, 271, '27842177', 'IB Corretora de Câmbio, Títulos e Valores Mobiliários S.A.', 'IB CCTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(178, 21, '28127603', 'BANESTES S.A. BANCO DO ESTADO DO ESPIRITO SANTO', 'BCO BANESTES S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(179, 246, '28195667', 'Banco ABC Brasil S.A.', 'BCO ABC BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(180, 292, '28650236', 'BS2 Distribuidora de Títulos e Valores Mobiliários S.A.', 'BS2 DTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(181, 751, '29030467', 'Scotiabank Brasil S.A. Banco Múltiplo', 'SCOTIABANK BRASIL', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(182, 352, '29162769', 'TORO CORRETORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'TORO CTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(183, 208, '30306294', 'Banco BTG Pactual S.A.', 'BANCO BTG PACTUAL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(184, 386, '30680829', 'NU FINANCEIRA S.A. - Sociedade de Crédito, Financiamento e Investimento', 'NU FINANCEIRA S.A. CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(185, 746, '30723886', 'Banco Modal S.A.', 'BCO MODAL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(186, 546, '30980539', 'U4C INSTITUIÇÃO DE PAGAMENTO S.A.', 'U4C INSTITUIÇÃO DE PAGAMENTO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(187, 241, '31597552', 'BANCO CLASSICO S.A.', 'BCO CLASSICO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(188, 398, '31749596', 'IDEAL CORRETORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'IDEAL CTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(189, 336, '31872495', 'Banco C6 S.A.', 'BCO C6 S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(190, 612, '31880826', 'Banco Guanabara S.A.', 'BCO GUANABARA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(191, 604, '31895683', 'Banco Industrial do Brasil S.A.', 'BCO INDUSTRIAL DO BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(192, 505, '32062580', 'Banco Credit Suisse (Brasil) S.A.', 'BCO CREDIT SUISSE S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(193, 329, '32402502', 'QI Sociedade de Crédito Direto S.A.', 'QI SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(194, 196, '32648370', 'FAIR CORRETORA DE CAMBIO S.A.', 'FAIR CC S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(195, 342, '32997490', 'Creditas Sociedade de Crédito Direto S.A.', 'CREDITAS SCD', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(196, 300, '33042151', 'Banco de la Nacion Argentina', 'BCO LA NACION ARGENTINA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(197, 477, '33042953', 'Citibank N.A.', 'CITIBANK N.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(198, 266, '33132044', 'BANCO CEDULA S.A.', 'BCO CEDULA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(199, 122, '33147315', 'Banco Bradesco BERJ S.A.', 'BCO BRADESCO BERJ S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(200, 376, '33172537', 'BANCO J.P. MORGAN S.A.', 'BCO J.P. MORGAN S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(201, 348, '33264668', 'Banco XP S.A.', 'BCO XP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(202, 473, '33466988', 'Banco Caixa Geral - Brasil S.A.', 'BCO CAIXA GERAL BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(203, 745, '33479023', 'Banco Citibank S.A.', 'BCO CITIBANK S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(204, 120, '33603457', 'BANCO RODOBENS S.A.', 'BCO RODOBENS S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(205, 265, '33644196', 'Banco Fator S.A.', 'BCO FATOR S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(206, 7, '33657248', 'BANCO NACIONAL DE DESENVOLVIMENTO ECONOMICO E SOCIAL', 'BNDES', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(207, 188, '33775974', 'ATIVA INVESTIMENTOS S.A. CORRETORA DE TÍTULOS, CÂMBIO E VALORES', 'ATIVA S.A. INVESTIMENTOS CCTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(208, 134, '33862244', 'BGC LIQUIDEZ DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA', 'BGC LIQUIDEZ DTVM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(209, 29, '33885724', 'Banco Itaú Consignado S.A.', 'BANCO ITAÚ CONSIGNADO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(210, 467, '33886862', 'MASTER S/A CORRETORA DE CâMBIO, TíTULOS E VALORES MOBILIáRIOS', 'MASTER S/A CCTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(211, 243, '33923798', 'BANCO MASTER S/A', 'BANCO MASTER', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(212, 397, '34088029', 'LISTO SOCIEDADE DE CREDITO DIRETO S.A.', 'LISTO SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(213, 78, '34111187', 'Haitong Banco de Investimento do Brasil S.A.', 'HAITONG BI DO BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(214, 525, '34265629', 'INTERCAM CORRETORA DE CÂMBIO LTDA.', 'INTERCAM CC LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(215, 355, '34335592', 'ÓTIMO SOCIEDADE DE CRÉDITO DIRETO S.A.', 'ÓTIMO SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(216, 367, '34711571', 'VITREO DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'VITREO DTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(217, 528, '34829992', 'REAG DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'REAG DTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(218, 445, '35551187', 'PLANTAE S.A. - CRÉDITO, FINANCIAMENTO E INVESTIMENTO', 'PLANTAE CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(219, 373, '35977097', 'UP.P SOCIEDADE DE EMPRÉSTIMO ENTRE PESSOAS S.A.', 'UP.P SEP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(220, 111, '36113876', 'OLIVEIRA TRUST DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIARIOS S.A.', 'OLIVEIRA TRUST DTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(221, 512, '36266751', 'FINVEST DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'FINVEST DTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(222, 516, '36583700', 'QISTA S.A. - CRÉDITO, FINANCIAMENTO E INVESTIMENTO', 'QISTA S.A. CFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(223, 408, '36586946', 'BONUSPAGO SOCIEDADE DE CRÉDITO DIRETO S.A.', 'BONUSPAGO SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(224, 484, '36864992', 'MAF DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'MAF DTVM SA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(225, 402, '36947229', 'COBUCCIO S/A - SOCIEDADE DE CRÉDITO, FINANCIAMENTO E INVESTIMENTOS', 'COBUCCIO S.A. SCFI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(226, 507, '37229413', 'SOCIEDADE DE CRÉDITO, FINANCIAMENTO E INVESTIMENTO EFÍ S.A.', 'SCFI EFÍ S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(227, 404, '37241230', 'SUMUP SOCIEDADE DE CRÉDITO DIRETO S.A.', 'SUMUP SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(228, 418, '37414009', 'ZIPDIN SOLUÇÕES DIGITAIS SOCIEDADE DE CRÉDITO DIRETO S/A', 'ZIPDIN SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(229, 414, '37526080', 'LEND SOCIEDADE DE CRÉDITO DIRETO S.A.', 'LEND SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(230, 449, '37555231', 'DM SOCIEDADE DE CRÉDITO DIRETO S.A.', 'DM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(231, 518, '37679449', 'MERCADO CRÉDITO SOCIEDADE DE CRÉDITO, FINANCIAMENTO E INVESTIMENTO S.A.', 'MERCADO CRÉDITO SCFI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(232, 406, '37715993', 'ACCREDITO - SOCIEDADE DE CRÉDITO DIRETO S.A.', 'ACCREDITO SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(233, 403, '37880206', 'CORA SOCIEDADE DE CRÉDITO DIRETO S.A.', 'CORA SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(234, 419, '38129006', 'NUMBRS SOCIEDADE DE CRÉDITO DIRETO S.A.', 'NUMBRS SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(235, 435, '38224857', 'DELCRED SOCIEDADE DE CRÉDITO DIRETO S.A.', 'DELCRED SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(236, 455, '38429045', 'FÊNIX DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'FÊNIX DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(237, 421, '39343350', 'LAR COOPERATIVA DE CRÉDITO - LAR CREDI', 'CC LAR CREDI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(238, 443, '39416705', 'CREDIHOME SOCIEDADE DE CRÉDITO DIRETO S.A.', 'CREDIHOME SCD', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(239, 535, '39519944', 'MARÚ SOCIEDADE DE CRÉDITO DIRETO S.A.', 'MARU SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(240, 457, '39587424', 'UY3 SOCIEDADE DE CRÉDITO DIRETO S/A', 'UY3 SCD S/A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(241, 428, '39664698', 'CREDSYSTEM SOCIEDADE DE CRÉDITO DIRETO S.A.', 'CREDSYSTEM SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(242, 448, '39669186', 'HEMERA DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'HEMERA DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(243, 452, '39676772', 'CREDIFIT SOCIEDADE DE CRÉDITO DIRETO S.A.', 'CREDIFIT SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(244, 510, '39738065', 'FFCRED SOCIEDADE DE CRÉDITO DIRETO S.A..', 'FFCRED SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(245, 462, '39908427', 'STARK SOCIEDADE DE CRÉDITO DIRETO S.A.', 'STARK SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(246, 465, '40083667', 'CAPITAL CONSIG SOCIEDADE DE CRÉDITO DIRETO S.A.', 'CAPITAL CONSIG SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(247, 306, '40303299', 'PORTOPAR DISTRIBUIDORA DE TITULOS E VALORES MOBILIARIOS LTDA.', 'PORTOPAR DTVM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(248, 463, '40434681', 'AZUMI DISTRIBUIDORA DE TíTULOS E VALORES MOBILIáRIOS LTDA.', 'AZUMI DTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(249, 451, '40475846', 'J17 - SOCIEDADE DE CRÉDITO DIRETO S/A', 'J17 - SCD S/A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(250, 444, '40654622', 'TRINUS SOCIEDADE DE CRÉDITO DIRETO S.A.', 'TRINUS SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(251, 519, '40768766', 'LIONS TRUST DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'LIONS TRUST DTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(252, 454, '41592532', 'MÉRITO DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'MÉRITO DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(253, 460, '42047025', 'UNAVANTI SOCIEDADE DE CRÉDITO DIRETO S/A', 'UNAVANTI SCD S/A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(254, 506, '42066258', 'RJI CORRETORA DE TITULOS E VALORES MOBILIARIOS LTDA', 'RJI', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(255, 482, '42259084', 'SBCASH SOCIEDADE DE CRÉDITO DIRETO S.A.', 'SBCASH SCD', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(256, 17, '42272526', 'BNY Mellon Banco S.A.', 'BNY MELLON BCO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(257, 174, '43180355', 'PEFISA S.A. - CRÉDITO, FINANCIAMENTO E INVESTIMENTO', 'PEFISA S.A. - C.F.I.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(258, 481, '43599047', 'SUPERLÓGICA SOCIEDADE DE CRÉDITO DIRETO S.A.', 'SUPERLÓGICA SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(259, 521, '44019481', 'PEAK SOCIEDADE DE EMPRÉSTIMO ENTRE PESSOAS S.A.', 'PEAK SEP S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(260, 433, '44077014', 'BR-CAPITAL DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'BR-CAPITAL DTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(261, 495, '44189447', 'Banco de La Provincia de Buenos Aires', 'BCO LA PROVINCIA B AIRES BCE', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(262, 523, '44292580', 'HR DIGITAL - SOCIEDADE DE CRÉDITO DIRETO S/A', 'HR DIGITAL SCD', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(263, 527, '44478623', 'ATICCA - SOCIEDADE DE CRÉDITO DIRETO S.A.', 'ATICCA SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(264, 511, '44683140', 'MAGNUM SOCIEDADE DE CRÉDITO DIRETO S.A.', 'MAGNUM SCD', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(265, 513, '44728700', 'ATF CREDIT SOCIEDADE DE CRÉDITO DIRETO S.A.', 'ATF CREDIT SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(266, 125, '45246410', 'BANCO GENIAL S.A.', 'BANCO GENIAL', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(267, 532, '45745537', 'EAGLE SOCIEDADE DE CRÉDITO DIRETO S.A.', 'EAGLE SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(268, 537, '45756448', 'MICROCASH SOCIEDADE DE CRÉDITO AO MICROEMPREENDEDOR E À EMPRESA DE PEQUENO PORTE', 'MICROCASH SCMEPP LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(269, 524, '45854066', 'WNT CAPITAL DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'WNT CAPITAL DTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(270, 526, '46026562', 'MONETARIE SOCIEDADE DE CRÉDITO DIRETO S.A.', 'MONETARIE SCD', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(271, 488, '46518205', 'JPMorgan Chase Bank, National Association', 'JPMORGAN CHASE BANK', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(272, 522, '47593544', 'RED SOCIEDADE DE CRÉDITO DIRETO S.A.', 'RED SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(273, 530, '47873449', 'SER FINANCE SOCIEDADE DE CRÉDITO DIRETO S.A.', 'SER FINANCE SCD S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(274, 65, '48795256', 'Banco AndBank (Brasil) S.A.', 'BCO ANDBANK S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(275, 145, '50579044', 'LEVYCAM - CORRETORA DE CAMBIO E VALORES LTDA.', 'LEVYCAM CCV LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(276, 250, '50585090', 'BCV - BANCO DE CRÉDITO E VAREJO S.A.', 'BCV - BCO, CRÉDITO E VAREJO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(277, 253, '52937216', 'Bexs Corretora de Câmbio S/A', 'BEXS CC S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(278, 269, '53518684', 'BANCO HSBC S.A.', 'BCO HSBC S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(279, 213, '54403563', 'Banco Arbi S.A.', 'BCO ARBI S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(280, 139, '55230916', 'Intesa Sanpaolo Brasil S.A. - Banco Múltiplo', 'INTESA SANPAOLO BRASIL S.A. BM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(281, 18, '57839805', 'Banco Tricury S.A.', 'BCO TRICURY S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(282, 422, '58160789', 'Banco Safra S.A.', 'BCO SAFRA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(283, 630, '58497702', 'BANCO LETSBANK S.A.', 'BCO LETSBANK S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(284, 224, '58616418', 'Banco Fibra S.A.', 'BCO FIBRA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(285, 393, '59109165', 'Banco Volkswagen S.A.', 'BCO VOLKSWAGEN S.A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(286, 600, '59118133', 'Banco Luso Brasileiro S.A.', 'BCO LUSO BRASILEIRO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(287, 390, '59274605', 'BANCO GM S.A.', 'BCO GM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(288, 623, '59285411', 'Banco Pan S.A.', 'BANCO PAN', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(289, 655, '59588111', 'Banco Votorantim S.A.', 'BCO VOTORANTIM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(290, 479, '60394079', 'Banco ItauBank S.A.', 'BCO ITAUBANK S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(291, 456, '60498557', 'Banco MUFG Brasil S.A.', 'BCO MUFG BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(292, 464, '60518222', 'Banco Sumitomo Mitsui Brasileiro S.A.', 'BCO SUMITOMO MITSUI BRASIL S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(293, 341, '60701190', 'ITAÚ UNIBANCO S.A.', 'ITAÚ UNIBANCO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(294, 237, '60746948', 'Banco Bradesco S.A.', 'BCO BRADESCO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(295, 381, '60814191', 'BANCO MERCEDES-BENZ DO BRASIL S.A.', 'BCO MERCEDES-BENZ S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(296, 613, '60850229', 'Omni Banco S.A.', 'OMNI BANCO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(297, 637, '60889128', 'BANCO SOFISA S.A.', 'BCO SOFISA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(298, 653, '61024352', 'BANCO VOITER S.A.', 'BANCO VOITER', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(299, 69, '61033106', 'Banco Crefisa S.A.', 'BCO CREFISA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(300, 370, '61088183', 'Banco Mizuho do Brasil S.A.', 'BCO MIZUHO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(301, 249, '61182408', 'Banco Investcred Unibanco S.A.', 'BANCO INVESTCRED UNIBANCO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(302, 318, '61186680', 'Banco BMG S.A.', 'BCO BMG S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(303, 626, '61348538', 'BANCO C6 CONSIGNADO S.A.', 'BCO C6 CONSIG', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(304, 508, '61384004', 'AVENUE SECURITIES DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'AVENUE SECURITIES DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(305, 270, '61444949', 'SAGITUR CORRETORA DE CÂMBIO S.A.', 'SAGITUR CC', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(306, 366, '61533584', 'BANCO SOCIETE GENERALE BRASIL S.A.', 'BCO SOCIETE GENERALE BRASIL', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(307, 113, '61723847', 'NEON CORRETORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'NEON CTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(308, 131, '61747085', 'TULLETT PREBON BRASIL CORRETORA DE VALORES E CÂMBIO LTDA', 'TULLETT PREBON BRASIL CVC LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(309, 11, '61809182', 'CREDIT SUISSE HEDGING-GRIFFO CORRETORA DE VALORES S.A', 'C.SUISSE HEDGING-GRIFFO CV S/A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(310, 611, '61820817', 'Banco Paulista S.A.', 'BCO PAULISTA S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(311, 755, '62073200', 'Bank of America Merrill Lynch Banco Múltiplo S.A.', 'BOFA MERRILL LYNCH BM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(312, 89, '62109566', 'CREDISAN COOPERATIVA DE CRÉDITO', 'CREDISAN CC', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(313, 643, '62144175', 'Banco Pine S.A.', 'BCO PINE S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(314, 140, '62169875', 'NU INVEST CORRETORA DE VALORES S.A.', 'NU INVEST CORRETORA DE VALORES S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(315, 707, '62232889', 'Banco Daycoval S.A.', 'BCO DAYCOVAL S.A', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(316, 288, '62237649', 'CAROL DISTRIBUIDORA DE TITULOS E VALORES MOBILIARIOS LTDA.', 'CAROL DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(317, 363, '62285390', 'SINGULARE CORRETORA DE TÍTULOS E VALORES MOBILIÁRIOS S.A.', 'SINGULARE CTVM S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(318, 101, '62287735', 'RENASCENCA DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA', 'RENASCENCA DTVM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(319, 487, '62331228', 'DEUTSCHE BANK S.A. - BANCO ALEMAO', 'DEUTSCHE BANK S.A.BCO ALEMAO', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(320, 233, '62421979', 'Banco Cifra S.A.', 'BANCO CIFRA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(321, 177, '65913436', 'Guide Investimentos S.A. Corretora de Valores', 'GUIDE', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(322, 438, '67030395', 'TRUSTEE DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA.', 'TRUSTEE DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(323, 365, '68757681', 'SIMPAUL CORRETORA DE CAMBIO E VALORES MOBILIARIOS  S.A.', 'SIMPAUL', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(324, 633, '68900810', 'Banco Rendimento S.A.', 'BCO RENDIMENTO S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(325, 218, '71027866', 'Banco BS2 S.A.', 'BCO BS2 S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(326, 293, '71590442', 'Lastro RDV Distribuidora de Títulos e Valores Mobiliários Ltda.', 'LASTRO RDV DTVM LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(327, 285, '71677850', 'FRENTE CORRETORA DE CÂMBIO S.A.', 'FRENTE CC S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(328, 80, '73622748', 'B&T CORRETORA DE CAMBIO LTDA.', 'B&T CC LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(329, 753, '74828799', 'Novo Banco Continental S.A. - Banco Múltiplo', 'NOVO BCO CONTINENTAL S.A. - BM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(330, 222, '75647891', 'BANCO CRÉDIT AGRICOLE BRASIL S.A.', 'BCO CRÉDIT AGRICOLE BR S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(331, 281, '76461557', 'Cooperativa de Crédito Rural Coopavel', 'CCR COOPAVEL', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(332, 754, '76543115', 'Banco Sistema S.A.', 'BANCO SISTEMA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(333, 311, '76641497', 'DOURADA CORRETORA DE CÂMBIO LTDA.', 'DOURADA CORRETORA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(334, 98, '78157146', 'Credialiança Cooperativa de Crédito Rural', 'CREDIALIANÇA CCR', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(335, 610, '78626983', 'Banco VR S.A.', 'BCO VR S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(336, 712, '78632767', 'Banco Ourinvest S.A.', 'BCO OURINVEST S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(337, 720, '80271455', 'BANCO RNX S.A.', 'BCO RNX S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(338, 10, '81723108', 'CREDICOAMO CREDITO RURAL COOPERATIVA', 'CREDICOAMO', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(339, 440, '82096447', 'CREDIBRF - COOPERATIVA DE CRÉDITO', 'CREDIBRF COOP', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(340, 442, '87963450', 'MAGNETIS - DISTRIBUIDORA DE TÍTULOS E VALORES MOBILIÁRIOS LTDA', 'MAGNETIS - DTVM', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(341, 283, '89960090', 'RB INVESTIMENTOS DISTRIBUIDORA DE TITULOS E VALORES MOBILIARIOS LIMITADA', 'RB INVESTIMENTOS DTVM LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(342, 33, '90400888', 'BANCO SANTANDER (BRASIL) S.A.', 'BCO SANTANDER (BRASIL) S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL);
INSERT INTO `financial_bank_institutions` (`id`, `code`, `ispb`, `name`, `short_name`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(343, 217, '91884981', 'Banco John Deere S.A.', 'BANCO JOHN DEERE S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(344, 41, '92702067', 'Banco do Estado do Rio Grande do Sul S.A.', 'BCO DO ESTADO DO RS S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(345, 117, '92856905', 'ADVANCED CORRETORA DE CÂMBIO LTDA', 'ADVANCED CC LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(346, 654, '92874270', 'BANCO DIGIMAIS S.A.', 'BCO DIGIMAIS S.A.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(347, 371, '92875780', 'WARREN CORRETORA DE VALORES MOBILIÁRIOS E CÂMBIO LTDA.', 'WARREN CVMC LTDA', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(348, 212, '92894922', 'Banco Original S.A.', 'BANCO ORIGINAL', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL),
(349, 289, '94968518', 'EFX CORRETORA DE CÂMBIO LTDA.', 'EFX CC LTDA.', '1', '2025-08-22 19:19:33', '2025-08-22 19:19:33', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `financial_categories`
--

CREATE TABLE `financial_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `order` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `status` char(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `financial_categories`
--

INSERT INTO `financial_categories` (`id`, `category_id`, `name`, `slug`, `order`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, NULL, 'Tráfego Pago', 'trafego-pago', 1, '1', '2025-08-22 21:02:04', '2025-08-22 21:02:04', NULL),
(2, NULL, 'Redes Sociais', 'redes-sociais', 1, '1', '2025-08-22 21:02:35', '2025-08-22 21:02:35', NULL),
(3, NULL, 'Saas', 'saas', 1, '1', '2025-08-22 21:12:10', '2025-08-22 21:12:10', NULL),
(4, NULL, 'I2C.Lares', 'i2c-lares', 1, '1', '2025-08-22 21:12:22', '2025-08-22 21:12:22', NULL),
(5, NULL, 'Hospedagem de Sites', 'hospedagem-de-sites', 1, '1', '2025-08-22 21:26:52', '2025-08-22 21:28:06', NULL),
(6, NULL, 'Manutenção / Consultoria', 'manutencao-consultoria', 1, '1', '2025-08-22 22:02:23', '2025-08-22 22:02:23', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `financial_category_financial_transaction`
--

CREATE TABLE `financial_category_financial_transaction` (
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `transaction_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `financial_category_financial_transaction`
--

INSERT INTO `financial_category_financial_transaction` (`category_id`, `transaction_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(1, 23),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(1, 31),
(1, 32),
(1, 33),
(1, 34),
(1, 35),
(1, 36),
(1, 37),
(1, 38),
(1, 39),
(1, 40),
(1, 41),
(1, 42),
(1, 43),
(1, 44),
(1, 45),
(1, 46),
(1, 47),
(1, 48),
(1, 49),
(1, 50),
(1, 51),
(1, 52),
(1, 53),
(1, 54),
(1, 55),
(1, 56),
(1, 57),
(1, 58),
(1, 59),
(1, 60),
(1, 61),
(1, 62),
(1, 63),
(1, 64),
(1, 65),
(1, 66),
(1, 67),
(1, 68),
(1, 69),
(1, 70),
(1, 71),
(1, 72),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(2, 15),
(2, 16),
(2, 17),
(2, 18),
(2, 19),
(2, 20),
(2, 21),
(2, 22),
(2, 23),
(2, 24),
(3, 73),
(3, 74),
(3, 75),
(3, 76),
(3, 77),
(3, 78),
(3, 79),
(3, 80),
(3, 81),
(3, 82),
(3, 83),
(3, 84),
(3, 85),
(3, 86),
(3, 87),
(3, 88),
(3, 89),
(3, 90),
(3, 91),
(3, 92),
(3, 93),
(3, 94),
(3, 95),
(3, 96),
(3, 97),
(3, 98),
(3, 99),
(3, 100),
(3, 101),
(3, 102),
(3, 103),
(3, 104),
(3, 105),
(3, 106),
(3, 107),
(3, 108),
(3, 109),
(3, 110),
(3, 111),
(3, 112),
(3, 113),
(3, 114),
(3, 115),
(3, 116),
(3, 117),
(3, 118),
(3, 119),
(3, 120),
(3, 121),
(3, 122),
(3, 123),
(3, 124),
(3, 125),
(3, 126),
(3, 127),
(3, 128),
(3, 129),
(3, 130),
(3, 131),
(3, 132),
(3, 133),
(3, 134),
(3, 135),
(3, 136),
(3, 137),
(3, 138),
(3, 139),
(3, 140),
(3, 141),
(3, 142),
(3, 143),
(3, 144),
(3, 145),
(3, 146),
(3, 147),
(3, 148),
(3, 149),
(3, 150),
(3, 151),
(3, 152),
(3, 153),
(3, 154),
(3, 155),
(3, 156),
(3, 157),
(3, 158),
(3, 159),
(3, 160),
(3, 161),
(3, 162),
(3, 163),
(3, 164),
(3, 165),
(3, 166),
(3, 167),
(3, 168),
(4, 73),
(4, 74),
(4, 75),
(4, 76),
(4, 77),
(4, 78),
(4, 79),
(4, 80),
(4, 81),
(4, 82),
(4, 83),
(4, 84),
(4, 85),
(4, 86),
(4, 87),
(4, 88),
(4, 89),
(4, 90),
(4, 91),
(4, 92),
(4, 93),
(4, 94),
(4, 95),
(4, 96),
(4, 97),
(4, 98),
(4, 99),
(4, 100),
(4, 101),
(4, 102),
(4, 103),
(4, 104),
(4, 105),
(4, 106),
(4, 107),
(4, 108),
(4, 109),
(4, 110),
(4, 111),
(4, 112),
(4, 113),
(4, 114),
(4, 115),
(4, 116),
(4, 117),
(4, 118),
(4, 119),
(4, 120),
(4, 121),
(4, 122),
(4, 123),
(4, 124),
(4, 125),
(4, 126),
(4, 127),
(4, 128),
(4, 129),
(4, 130),
(4, 131),
(4, 132),
(4, 133),
(4, 134),
(4, 135),
(4, 136),
(4, 137),
(4, 138),
(4, 139),
(4, 140),
(4, 141),
(4, 142),
(4, 143),
(4, 144),
(4, 145),
(4, 146),
(4, 147),
(4, 148),
(4, 149),
(4, 150),
(4, 151),
(4, 152),
(4, 153),
(4, 154),
(4, 155),
(4, 156),
(4, 157),
(4, 158),
(4, 159),
(4, 160),
(4, 161),
(4, 162),
(4, 163),
(4, 164),
(4, 165),
(4, 166),
(4, 167),
(4, 168),
(5, 169),
(5, 170),
(5, 171),
(5, 172),
(5, 173),
(5, 174),
(5, 175),
(5, 176),
(5, 177),
(5, 178),
(5, 179),
(5, 180),
(5, 181),
(5, 182),
(5, 183),
(5, 184),
(5, 185),
(5, 186),
(5, 187),
(5, 188),
(5, 189),
(5, 190),
(5, 191),
(5, 192),
(5, 193),
(5, 194),
(5, 195),
(5, 196),
(5, 197),
(5, 198),
(5, 199),
(5, 200),
(5, 201),
(5, 202),
(5, 203),
(5, 204),
(5, 205),
(5, 206),
(5, 207),
(5, 208),
(5, 209),
(5, 210),
(5, 211),
(5, 212),
(5, 213),
(5, 214),
(5, 215),
(5, 216),
(5, 229),
(5, 230),
(5, 231),
(5, 232),
(5, 233),
(5, 234),
(5, 235),
(5, 236),
(5, 237),
(5, 238),
(5, 239),
(5, 240),
(5, 241),
(5, 242),
(5, 243),
(5, 244),
(5, 245),
(5, 246),
(5, 247),
(5, 248),
(5, 249),
(5, 250),
(5, 251),
(5, 252),
(5, 253),
(5, 254),
(5, 255),
(5, 256),
(5, 257),
(5, 258),
(5, 259),
(5, 260),
(5, 261),
(5, 262),
(5, 263),
(5, 264),
(5, 265),
(5, 266),
(5, 267),
(5, 268),
(5, 269),
(5, 270),
(5, 271),
(5, 272),
(5, 273),
(5, 274),
(5, 275),
(5, 276),
(5, 277),
(5, 278),
(5, 279),
(5, 280),
(5, 281),
(5, 282),
(5, 283),
(5, 284),
(5, 285),
(5, 286),
(5, 287),
(5, 288),
(5, 290),
(5, 291),
(5, 292),
(5, 293),
(5, 294),
(5, 295),
(5, 296),
(5, 297),
(5, 298),
(5, 299),
(5, 300),
(5, 301),
(5, 302),
(5, 303),
(5, 304),
(5, 305),
(5, 306),
(5, 307),
(5, 308),
(5, 309),
(5, 310),
(5, 311),
(5, 312),
(5, 313),
(5, 314),
(5, 315),
(5, 316),
(5, 317),
(5, 318),
(5, 319),
(5, 320),
(5, 321),
(5, 322),
(5, 323),
(5, 324),
(5, 325),
(6, 289);

-- --------------------------------------------------------

--
-- Estrutura da tabela `financial_transactions`
--

CREATE TABLE `financial_transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `bank_account_id` bigint(20) UNSIGNED NOT NULL,
  `contact_id` bigint(20) UNSIGNED DEFAULT NULL,
  `business_id` bigint(20) UNSIGNED DEFAULT NULL,
  `transaction_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role` char(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `payment_method` char(1) DEFAULT NULL,
  `repeat_payment` char(1) NOT NULL DEFAULT '1',
  `repeat_occurrence` int(11) NOT NULL,
  `repeat_frequency` char(1) DEFAULT NULL,
  `repeat_index` int(11) NOT NULL DEFAULT 1,
  `price` bigint(20) NOT NULL,
  `interest` bigint(20) DEFAULT NULL,
  `fine` bigint(20) DEFAULT NULL,
  `discount` bigint(20) DEFAULT NULL,
  `taxes` bigint(20) DEFAULT NULL,
  `final_price` bigint(20) NOT NULL,
  `complement` varchar(255) DEFAULT NULL,
  `due_at` timestamp NULL DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `financial_transactions`
--

INSERT INTO `financial_transactions` (`id`, `user_id`, `bank_account_id`, `contact_id`, `business_id`, `transaction_id`, `role`, `name`, `payment_method`, `repeat_payment`, `repeat_occurrence`, `repeat_frequency`, `repeat_index`, `price`, `interest`, `fine`, `discount`, `taxes`, `final_price`, `complement`, `due_at`, `paid_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 1, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2025-09-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:40', NULL),
(2, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 2, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2025-10-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:40', NULL),
(3, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 3, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2025-11-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(4, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 4, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2025-12-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(5, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 5, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-01-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(6, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 6, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-02-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(7, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 7, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-03-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(8, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 8, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-04-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(9, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 9, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-05-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(10, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 10, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-06-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(11, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 11, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-07-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(12, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 12, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-08-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(13, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 13, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-09-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(14, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 14, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-10-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(15, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 15, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-11-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(16, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 16, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2026-12-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(17, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 17, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2027-01-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(18, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 18, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2027-02-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(19, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 19, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2027-03-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(20, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 20, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2027-04-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(21, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 21, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2027-05-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(22, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 22, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2027-06-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(23, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 23, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2027-07-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(24, 2, 3, 23, NULL, 1, '2', 'Gestão de Marketing (Tráfego Pago + Conteúdo p/ Redes Sociais)', '4', '3', 24, '3', 24, 72000, NULL, NULL, NULL, NULL, 72000, NULL, '2027-08-05 03:00:00', NULL, '2025-08-22 21:03:36', '2025-08-22 21:05:41', NULL),
(25, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 1, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2025-09-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(26, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 2, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2025-10-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(27, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 3, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2025-11-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(28, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 4, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2025-12-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(29, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 5, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-01-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(30, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 6, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-02-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(31, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 7, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-03-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(32, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 8, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-04-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(33, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 9, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-05-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(34, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 10, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-06-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(35, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 11, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-07-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(36, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 12, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-08-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(37, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 13, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-09-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(38, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 14, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-10-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(39, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 15, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-11-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(40, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 16, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-12-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(41, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 17, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-01-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(42, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 18, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-02-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(43, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 19, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-03-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(44, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 20, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-04-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(45, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 21, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-05-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(46, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 22, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-06-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(47, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 23, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-07-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(48, 2, 3, 19, NULL, 25, '2', 'Gestão de Tráfego Pago - Canopus', '4', '3', 24, '3', 24, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-08-10 03:00:00', NULL, '2025-08-22 21:09:14', '2025-08-22 21:09:14', NULL),
(49, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 1, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2025-09-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(50, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 2, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2025-10-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(51, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 3, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2025-11-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(52, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 4, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2025-12-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(53, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 5, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-01-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(54, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 6, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-02-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(55, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 7, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-03-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(56, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 8, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-04-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(57, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 9, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-05-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(58, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 10, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-06-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(59, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 11, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-07-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(60, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 12, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-08-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(61, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 13, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-09-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(62, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 14, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-10-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(63, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 15, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-11-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(64, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 16, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2026-12-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(65, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 17, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-01-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(66, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 18, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-02-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(67, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 19, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-03-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(68, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 20, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-04-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(69, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 21, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-05-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(70, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 22, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-06-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(71, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 23, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-07-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(72, 2, 3, 25, NULL, 49, '2', 'Gestão de Tráfego Pago', '4', '3', 24, '3', 24, 32000, NULL, NULL, NULL, NULL, 32000, NULL, '2027-08-05 03:00:00', NULL, '2025-08-22 21:10:56', '2025-08-22 21:10:56', NULL),
(73, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 1, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-09-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(74, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 2, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-10-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(75, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 3, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-11-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(76, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 4, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-12-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(77, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 5, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-01-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(78, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 6, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-02-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(79, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 7, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-03-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(80, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 8, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-04-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(81, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 9, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-05-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(82, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 10, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-06-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(83, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 11, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-07-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(84, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 12, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-08-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(85, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 13, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-09-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(86, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 14, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-10-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(87, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 15, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-11-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(88, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 16, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-12-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(89, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 17, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-01-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(90, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 18, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-02-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(91, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 19, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-03-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(92, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 20, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-04-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(93, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 21, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-05-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(94, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 22, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-06-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(95, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 23, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-07-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(96, 2, 4, 4, NULL, 73, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 24, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-08-05 03:00:00', NULL, '2025-08-22 21:15:09', '2025-08-22 21:15:09', NULL),
(97, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 1, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-09-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(98, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 2, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-10-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(99, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 3, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-11-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(100, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 4, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-12-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(101, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 5, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-01-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(102, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 6, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-02-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(103, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 7, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-03-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(104, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 8, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-04-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(105, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 9, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-05-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(106, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 10, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-06-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(107, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 11, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-07-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(108, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 12, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-08-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(109, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 13, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-09-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(110, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 14, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-10-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(111, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 15, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-11-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(112, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 16, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-12-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(113, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 17, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-01-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(114, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 18, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-02-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(115, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 19, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-03-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(116, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 20, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-04-05 03:00:00', NULL, '2025-08-22 21:20:01', '2025-08-22 21:20:01', NULL),
(117, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 21, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-05-05 03:00:00', NULL, '2025-08-22 21:20:02', '2025-08-22 21:20:02', NULL),
(118, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 22, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-06-05 03:00:00', NULL, '2025-08-22 21:20:02', '2025-08-22 21:20:02', NULL),
(119, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 23, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-07-05 03:00:00', NULL, '2025-08-22 21:20:02', '2025-08-22 21:20:02', NULL),
(120, 2, 4, 8, NULL, 97, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 24, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-08-05 03:00:00', NULL, '2025-08-22 21:20:02', '2025-08-22 21:20:02', NULL),
(121, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 1, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-09-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(122, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 2, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-10-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(123, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 3, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-11-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(124, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 4, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2025-12-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(125, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 5, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-01-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(126, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 6, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-02-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(127, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 7, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-03-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(128, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 8, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-04-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(129, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 9, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-05-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(130, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 10, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-06-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(131, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 11, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-07-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(132, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 12, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-08-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(133, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 13, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-09-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(134, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 14, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-10-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(135, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 15, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-11-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(136, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 16, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2026-12-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(137, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 17, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-01-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(138, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 18, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-02-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(139, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 19, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-03-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(140, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 20, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-04-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(141, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 21, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-05-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(142, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 22, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-06-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(143, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 23, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-07-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(144, 2, 4, 7, NULL, 121, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 24, 7590, NULL, NULL, NULL, NULL, 7590, NULL, '2027-08-05 03:00:00', NULL, '2025-08-22 21:23:10', '2025-08-22 21:23:10', NULL),
(145, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 1, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2025-09-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(146, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 2, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2025-10-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(147, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 3, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2025-11-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(148, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 4, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2025-12-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(149, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 5, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-01-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(150, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 6, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-02-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(151, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 7, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-03-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(152, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 8, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-04-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(153, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 9, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-05-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(154, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 10, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-06-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(155, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 11, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-07-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(156, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 12, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-08-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(157, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 13, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-09-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(158, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 14, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-10-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(159, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 15, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-11-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(160, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 16, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2026-12-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(161, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 17, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2027-01-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(162, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 18, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2027-02-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(163, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 19, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2027-03-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(164, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 20, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2027-04-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(165, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 21, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2027-05-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(166, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 22, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2027-06-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(167, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 23, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2027-07-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(168, 2, 4, 3, NULL, 145, '2', 'Mensalidade Saas I2C.Lares', '4', '3', 24, '3', 24, 7990, NULL, NULL, NULL, NULL, 7990, NULL, '2027-08-05 03:00:00', NULL, '2025-08-22 21:24:07', '2025-08-22 21:24:07', NULL),
(169, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 1, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-09-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(170, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 2, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-10-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(171, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 3, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-11-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(172, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 4, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-12-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(173, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 5, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-01-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(174, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 6, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-02-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(175, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 7, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-03-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(176, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 8, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-04-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(177, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 9, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-05-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(178, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 10, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-06-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(179, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 11, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-07-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(180, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 12, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-08-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(181, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 13, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-09-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(182, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 14, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-10-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(183, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 15, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-11-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(184, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 16, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-12-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(185, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 17, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-01-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(186, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 18, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-02-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(187, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 19, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-03-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(188, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 20, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-04-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(189, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 21, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-05-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(190, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 22, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-06-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(191, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 23, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-07-10 03:00:00', NULL, '2025-08-22 21:27:42', '2025-08-22 21:27:42', NULL),
(192, 2, 2, 13, NULL, 169, '2', 'Hospedagem do website - https://elitepisos.com.br', '4', '3', 24, '3', 24, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-08-10 03:00:00', NULL, '2025-08-22 21:27:43', '2025-08-22 21:27:43', NULL),
(193, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 1, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-09-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:34', NULL),
(194, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 2, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-10-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(195, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 3, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-11-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(196, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 4, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-12-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(197, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 5, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-01-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(198, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 6, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-02-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(199, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 7, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-03-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(200, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 8, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-04-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(201, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 9, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-05-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(202, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 10, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-06-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(203, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 11, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-07-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(204, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 12, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-08-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(205, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 13, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-09-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(206, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 14, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-10-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(207, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 15, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-11-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(208, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 16, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-12-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(209, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 17, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-01-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(210, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 18, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-02-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(211, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 19, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-03-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(212, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 20, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-04-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(213, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 21, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-05-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(214, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 22, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-06-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(215, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 23, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-07-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(216, 2, 2, 20, NULL, 193, '2', 'Hospedagem dos emails @ibericametalica.com.br', '4', '3', 24, '3', 24, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-08-05 03:00:00', NULL, '2025-08-22 21:30:33', '2025-08-22 21:39:56', NULL),
(229, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 1, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2026-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(230, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 2, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2027-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(231, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 3, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2028-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(232, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 4, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2029-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(233, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 5, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2030-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(234, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 6, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2031-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(235, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 7, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2032-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(236, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 8, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2033-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(237, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 9, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2034-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(238, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 10, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2035-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(239, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 11, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2036-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(240, 2, 2, 16, NULL, 229, '2', 'Hospedagem do website - https://flexcentroempresarial.com.br (anual)', '4', '3', 12, '7', 12, 42000, NULL, NULL, NULL, NULL, 42000, NULL, '2037-02-28 03:00:00', NULL, '2025-08-22 21:35:48', '2025-08-22 21:35:48', NULL),
(241, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 1, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2025-08-28 03:00:00', NULL, '2025-08-22 21:42:01', '2025-08-22 21:42:01', NULL);
INSERT INTO `financial_transactions` (`id`, `user_id`, `bank_account_id`, `contact_id`, `business_id`, `transaction_id`, `role`, `name`, `payment_method`, `repeat_payment`, `repeat_occurrence`, `repeat_frequency`, `repeat_index`, `price`, `interest`, `fine`, `discount`, `taxes`, `final_price`, `complement`, `due_at`, `paid_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(242, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 2, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2026-08-28 03:00:00', NULL, '2025-08-22 21:42:01', '2025-08-22 21:42:01', NULL),
(243, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 3, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2027-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(244, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 4, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2028-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(245, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 5, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2029-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(246, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 6, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2030-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(247, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 7, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2031-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(248, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 8, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2032-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(249, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 9, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2033-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(250, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 10, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2034-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(251, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 11, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2035-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(252, 2, 2, 11, NULL, 241, '2', 'Hospedagem dos emails @dcaconsultoria.eng.br (anual)', '4', '3', 12, '7', 12, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2036-08-28 03:00:00', NULL, '2025-08-22 21:42:02', '2025-08-22 21:42:02', NULL),
(253, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 1, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2026-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(254, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 2, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2027-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(255, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 3, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2028-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(256, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 4, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2029-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(257, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 5, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2030-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(258, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 6, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2031-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(259, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 7, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2032-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(260, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 8, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2033-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(261, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 9, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2034-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(262, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 10, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2035-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(263, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 11, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2036-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(264, 2, 2, 21, NULL, 253, '2', 'Hospedagem dos emails @leandroadv.com.br (anual)', '4', '3', 12, '7', 12, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2037-07-10 03:00:00', NULL, '2025-08-22 21:44:30', '2025-08-22 21:44:30', NULL),
(265, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 1, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2026-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(266, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 2, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2027-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(267, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 3, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2028-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(268, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 4, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2029-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(269, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 5, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2030-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(270, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 6, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2031-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(271, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 7, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2032-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(272, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 8, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2033-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(273, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 9, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2034-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(274, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 10, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2035-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(275, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 11, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2036-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(276, 2, 2, 1, NULL, 265, '2', 'Hospedagem dos emails @consulteng.eng.br (anual)', '4', '3', 12, '7', 12, 21600, NULL, NULL, NULL, NULL, 21600, NULL, '2037-07-10 03:00:00', NULL, '2025-08-22 21:46:35', '2025-08-22 21:58:15', NULL),
(277, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 1, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2026-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(278, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 2, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2027-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(279, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 3, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2028-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(280, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 4, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2029-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(281, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 5, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2030-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(282, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 6, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2031-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(283, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 7, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2032-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(284, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 8, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2033-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(285, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 9, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2034-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(286, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 10, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2035-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(287, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 11, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2036-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(288, 2, 2, 27, NULL, 277, '2', 'Hospedagem do website https://paulozanella.com.br (anual)', '4', '3', 12, '7', 12, 12000, NULL, NULL, NULL, NULL, 12000, NULL, '2037-07-10 03:00:00', NULL, '2025-08-22 21:54:02', '2025-08-22 21:54:02', NULL),
(289, 2, 2, 15, NULL, NULL, '2', 'Manutenção DNS - CDN dos emails da hospedagem @exho.com.br', '4', '1', 1, NULL, 1, 30000, NULL, NULL, NULL, NULL, 30000, NULL, '2025-09-15 03:00:00', NULL, '2025-08-22 22:02:54', '2025-08-22 22:02:54', NULL),
(290, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 1, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-08-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(291, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 2, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-09-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(292, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 3, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-10-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(293, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 4, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-11-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(294, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 5, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2025-12-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(295, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 6, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-01-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(296, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 7, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-02-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(297, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 8, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-03-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(298, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 9, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-04-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(299, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 10, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-05-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(300, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 11, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-06-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(301, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 12, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-07-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(302, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 13, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-08-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(303, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 14, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-09-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(304, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 15, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-10-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(305, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 16, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-11-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(306, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 17, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2026-12-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(307, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 18, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-01-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(308, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 19, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-02-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(309, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 20, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-03-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(310, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 21, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-04-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(311, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 22, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-05-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(312, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 23, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-06-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(313, 2, 2, 29, NULL, 290, '2', 'Hospedagem do website https://estruturalpisosevidros.com.br', '4', '3', 24, '3', 24, 2500, NULL, NULL, NULL, NULL, 2500, NULL, '2027-07-20 03:00:00', NULL, '2025-08-22 22:11:19', '2025-08-22 22:11:19', NULL),
(314, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 1, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2026-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(315, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 2, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2027-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(316, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 3, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2028-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(317, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 4, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2029-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(318, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 5, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2030-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(319, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 6, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2031-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(320, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 7, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2032-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(321, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 8, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2033-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(322, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 9, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2034-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(323, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 10, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2035-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(324, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 11, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2036-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL),
(325, 1, 2, 32, NULL, 314, '2', 'Hospedagem dos e-mails @nobisarquitetura.com.br (anual)', '4', '3', 12, '7', 12, 27000, NULL, NULL, NULL, NULL, 27000, NULL, '2037-06-05 03:00:00', NULL, '2025-08-25 18:30:59', '2025-08-25 18:30:59', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `media`
--

CREATE TABLE `media` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) DEFAULT NULL,
  `collection_name` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(255) DEFAULT NULL,
  `disk` varchar(255) NOT NULL,
  `conversions_disk` varchar(255) DEFAULT NULL,
  `size` bigint(20) UNSIGNED NOT NULL,
  `manipulations` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`manipulations`)),
  `custom_properties` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`custom_properties`)),
  `generated_conversions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`generated_conversions`)),
  `responsive_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`responsive_images`)),
  `order_column` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `media`
--

INSERT INTO `media` (`id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type`, `disk`, `conversions_disk`, `size`, `manipulations`, `custom_properties`, `generated_conversions`, `responsive_images`, `order_column`, `created_at`, `updated_at`) VALUES
(1, 'users', 2, 'f4f839bc-4f44-45a6-b11e-23734a8c432d', 'avatar', 'Lemos-avatar1', 'vinicius-calaca-lemos-4905f94bfa016de8a15804e71cfef75d-1755879736.jpg', 'image/jpeg', 'public', 'public', 26396, '[]', '[]', '{\"thumb\":true}', '[]', 1, '2025-08-22 19:22:16', '2025-08-22 19:22:16'),
(2, 'agencies', 1, '4d775bdf-9110-4c45-a3a9-6ac37b9f2488', 'avatar', 'incloud14', 'incloudsistemas-460219926e285795c94a7e4a248d2d35-1755879880.jpg', 'image/jpeg', 'public', 'public', 21515, '[]', '[]', '{\"thumb\":true}', '[]', 1, '2025-08-22 19:24:40', '2025-08-22 19:24:40'),
(3, 'agencies', 2, 'e4726082-e4ea-45d7-bb01-3e53b473e67c', 'avatar', 'incloud10', 'inclouddigital-069cfda9a52b356cb19cf3d9b9462f2c-1755879928.png', 'image/png', 'public', 'public', 39212, '[]', '[]', '{\"thumb\":true}', '[]', 1, '2025-08-22 19:25:28', '2025-08-22 19:25:29'),
(4, 'agencies', 3, 'b7ce340f-b22a-4047-b08d-2edaf1463915', 'avatar', 'incloud-imob13', 'i2clares-727ee8b21e44ca782b84770ab238597f-1755880068.jpg', 'image/jpeg', 'public', 'public', 28837, '[]', '[]', '{\"thumb\":true}', '[]', 1, '2025-08-22 19:27:48', '2025-08-22 19:27:48');

-- --------------------------------------------------------

--
-- Estrutura da tabela `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_03_06_193612_add_custom_attributes_to_users_table', 1),
(5, '2025_03_06_193614_create_addresses_table', 1),
(6, '2025_03_10_184939_create_media_table', 1),
(7, '2025_03_10_185106_create_permission_tables', 1),
(8, '2025_05_02_183309_create_crm_sources_table', 1),
(9, '2025_05_02_183325_create_crm_contact_roles_table', 1),
(10, '2025_05_02_183336_create_crm_contacts_table', 1),
(11, '2025_05_02_183343_create_crm_contact_individuals_table', 1),
(12, '2025_05_02_183350_create_crm_contact_legal_entities_table', 1),
(13, '2025_05_02_183400_create_crm_contact_crm_contact_role_table', 1),
(14, '2025_05_02_183416_create_crm_contact_individual_crm_contact_legal_entity_table', 1),
(15, '2025_05_20_113152_create_crm_funnels_table', 1),
(16, '2025_05_20_113159_create_crm_funnel_stages_table', 1),
(17, '2025_05_20_113206_create_crm_funnel_substages_table', 1),
(18, '2025_05_20_113221_create_crm_business_table', 1),
(19, '2025_05_20_113229_create_crm_business_funnel_stages_table', 1),
(20, '2025_05_20_113237_create_crm_business_user_table', 1),
(21, '2025_06_02_184407_create_agencies_table', 1),
(22, '2025_06_02_184414_create_agency_user_table', 1),
(23, '2025_06_02_184421_create_teams_table', 1),
(24, '2025_06_02_184428_create_team_user_table', 1),
(25, '2025_06_13_121028_create_activities_table', 1),
(26, '2025_06_13_121034_create_activity_notes_table', 1),
(27, '2025_06_13_121041_create_activity_emails_table', 1),
(28, '2025_06_13_121046_create_activity_tasks_table', 1),
(29, '2025_06_13_121052_create_activity_user_table', 1),
(30, '2025_06_13_121058_create_activity_crm_contact_table', 1),
(31, '2025_07_08_114831_create_financial_categories_table', 1),
(32, '2025_07_08_114841_create_financial_bank_institutions_table', 1),
(33, '2025_07_08_114844_create_financial_bank_accounts_table', 1),
(34, '2025_07_08_114850_create_financial_transactions_table', 1),
(35, '2025_07_08_114856_create_financial_category_financial_transaction_table', 1),
(36, '2025_07_22_143957_create_activity_log_table', 1),
(37, '2025_07_22_143958_add_event_column_to_activity_log_table', 1),
(38, '2025_07_22_143959_add_batch_uuid_column_to_activity_log_table', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'users', 1),
(3, 'users', 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'Cadastrar Usuários', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(2, 'Visualizar Usuários', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(3, 'Editar Usuários', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(4, 'Deletar Usuários', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(5, 'Cadastrar Níveis de Acessos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(6, 'Visualizar Níveis de Acessos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(7, 'Editar Níveis de Acessos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(8, 'Deletar Níveis de Acessos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(9, 'Cadastrar Agências', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(10, 'Visualizar Agências', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(11, 'Editar Agências', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(12, 'Deletar Agências', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(13, 'Cadastrar Equipes', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(14, 'Visualizar Equipes', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(15, 'Editar Equipes', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(16, 'Deletar Equipes', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(17, 'Cadastrar [CRM] Origens dos Contatos/Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(18, 'Visualizar [CRM] Origens dos Contatos/Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(19, 'Editar [CRM] Origens dos Contatos/Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(20, 'Deletar [CRM] Origens dos Contatos/Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(21, 'Cadastrar [CRM] Tipos de Contatos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(22, 'Visualizar [CRM] Tipos de Contatos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(23, 'Editar [CRM] Tipos de Contatos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(24, 'Deletar [CRM] Tipos de Contatos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(25, 'Cadastrar [CRM] Contatos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(26, 'Visualizar [CRM] Contatos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(27, 'Editar [CRM] Contatos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(28, 'Deletar [CRM] Contatos', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(29, 'Cadastrar [CRM] Funis de Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(30, 'Visualizar [CRM] Funis de Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(31, 'Editar [CRM] Funis de Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(32, 'Deletar [CRM] Funis de Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(33, 'Cadastrar [CRM] Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(34, 'Visualizar [CRM] Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(35, 'Editar [CRM] Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(36, 'Deletar [CRM] Negócios', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(37, 'Cadastrar [Financeiro] Instituições Bancárias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(38, 'Visualizar [Financeiro] Instituições Bancárias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(39, 'Editar [Financeiro] Instituições Bancárias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(40, 'Deletar [Financeiro] Instituições Bancárias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(41, 'Cadastrar [Financeiro] Contas Bancárias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(42, 'Visualizar [Financeiro] Contas Bancárias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(43, 'Editar [Financeiro] Contas Bancárias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(44, 'Deletar [Financeiro] Contas Bancárias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(45, 'Cadastrar [Financeiro] Transações Financeiras', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(46, 'Visualizar [Financeiro] Transações Financeiras', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(47, 'Editar [Financeiro] Transações Financeiras', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(48, 'Deletar [Financeiro] Transações Financeiras', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(49, 'Cadastrar [Financeiro] Categorias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(50, 'Visualizar [Financeiro] Categorias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(51, 'Editar [Financeiro] Categorias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(52, 'Deletar [Financeiro] Categorias', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24');

-- --------------------------------------------------------

--
-- Estrutura da tabela `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'Superadministrador', 'web', '2025-08-22 19:19:23', '2025-08-22 19:19:23'),
(2, 'Cliente', 'web', '2025-08-22 19:19:24', '2025-08-22 19:19:24'),
(3, 'Administrador', 'web', '2025-08-22 19:19:25', '2025-08-22 19:19:25'),
(4, 'Líder', 'web', '2025-08-22 19:19:26', '2025-08-22 19:19:26'),
(5, 'Coordenador', 'web', '2025-08-22 19:19:27', '2025-08-22 19:19:27'),
(6, 'Colaborador', 'web', '2025-08-22 19:19:28', '2025-08-22 19:19:28'),
(7, 'Financeiro', 'web', '2025-08-22 19:19:29', '2025-08-22 19:19:29'),
(8, 'Marketing', 'web', '2025-08-22 19:19:30', '2025-08-22 19:19:30');

-- --------------------------------------------------------

--
-- Estrutura da tabela `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 1),
(1, 3),
(2, 1),
(2, 3),
(3, 1),
(3, 3),
(4, 1),
(4, 3),
(5, 1),
(5, 3),
(6, 1),
(6, 3),
(7, 1),
(7, 3),
(8, 1),
(8, 3),
(9, 1),
(9, 3),
(10, 1),
(10, 3),
(11, 1),
(11, 3),
(12, 1),
(12, 3),
(13, 1),
(13, 3),
(14, 1),
(14, 3),
(15, 1),
(15, 3),
(16, 1),
(16, 3),
(17, 1),
(17, 3),
(18, 1),
(18, 3),
(19, 1),
(19, 3),
(20, 1),
(20, 3),
(21, 1),
(21, 3),
(22, 1),
(22, 3),
(23, 1),
(23, 3),
(24, 1),
(24, 3),
(25, 1),
(25, 3),
(25, 4),
(25, 5),
(25, 6),
(26, 1),
(26, 3),
(26, 4),
(26, 5),
(26, 6),
(27, 1),
(27, 3),
(27, 4),
(27, 5),
(27, 6),
(28, 1),
(28, 3),
(28, 4),
(28, 5),
(28, 6),
(29, 1),
(29, 3),
(30, 1),
(30, 3),
(31, 1),
(31, 3),
(32, 1),
(32, 3),
(33, 1),
(33, 3),
(33, 4),
(33, 5),
(33, 6),
(34, 1),
(34, 3),
(34, 4),
(34, 5),
(34, 6),
(35, 1),
(35, 3),
(35, 4),
(35, 5),
(35, 6),
(36, 1),
(36, 3),
(36, 4),
(36, 5),
(36, 6),
(37, 1),
(38, 1),
(39, 1),
(40, 1),
(41, 1),
(41, 3),
(41, 7),
(42, 1),
(42, 3),
(42, 7),
(43, 1),
(43, 3),
(43, 7),
(44, 1),
(44, 3),
(44, 7),
(45, 1),
(45, 3),
(45, 7),
(46, 1),
(46, 3),
(46, 7),
(47, 1),
(47, 3),
(47, 7),
(48, 1),
(48, 3),
(48, 7),
(49, 1),
(49, 3),
(49, 7),
(50, 1),
(50, 3),
(50, 7),
(51, 1),
(51, 3),
(51, 7),
(52, 1),
(52, 3),
(52, 7);

-- --------------------------------------------------------

--
-- Estrutura da tabela `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('9YsYwY6bpygUA7a9YVurfdKQTKe8rVE8CbFb26LT', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTo2OntzOjY6Il90b2tlbiI7czo0MDoiaEtJZjNuZ2Vlcnp0cnpvZ1lINmc4Sjk2dUlDbXlodFYyeFlLY0dJTyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTI6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9pMmMtYWRtaW4vZmluYW5jaWFsL2NhdGVnb3JpZXMiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO3M6MTc6InBhc3N3b3JkX2hhc2hfd2ViIjtzOjYwOiIkMnkkMTIkSGcuc0ZTNDdZNnZCVnM4MGx6STdjdVRreGxQU2g1ZXVKazZ4TW9xMmFvNG1pMm9jeUJTaU8iO3M6ODoiZmlsYW1lbnQiO2E6MDp7fX0=', 1756136932),
('Dnyn7yzj96RPn8UZG4uI2VilLXjx3s0hSwf0scbu', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiZVlLdW5vU1lCa3RncUFBaTVwWjV6SWFCNlRmS2ZENUVBbm5rbUxVcyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1756131971);

-- --------------------------------------------------------

--
-- Estrutura da tabela `teams`
--

CREATE TABLE `teams` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `agency_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `complement` text DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `team_user`
--

CREATE TABLE `team_user` (
  `team_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `role` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `additional_emails` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional_emails`)),
  `phones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`phones`)),
  `cpf` varchar(255) DEFAULT NULL,
  `rg` varchar(255) DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `marital_status` char(1) DEFAULT NULL,
  `educational_level` char(1) DEFAULT NULL,
  `nationality` varchar(255) DEFAULT NULL,
  `citizenship` varchar(255) DEFAULT NULL,
  `complement` text DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '1',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `additional_emails`, `phones`, `cpf`, `rg`, `gender`, `birth_date`, `marital_status`, `educational_level`, `nationality`, `citizenship`, `complement`, `status`, `remember_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'a i o n', 'contato@incloudsistemas.com.br', '2025-08-22 19:19:31', '$2y$12$Hg.sFS47Y6vBVs80lzI7cuTkxlPSh5euJk6xMoq2ao4mi2ocyBSiO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '5kspCF8aJ4RZrCre8CxVpPPMD1STalnAmAhlzFlYpkCO1Rczlz6EMVL7FgYy', '2025-08-22 19:19:32', '2025-08-22 19:19:32', NULL),
(2, 'Vinícius Calaça Lemos', 'emaildocalaca@gmail.com', NULL, '$2y$12$l7wFOc3fb1FQqC9xsJsKLecpOq0K4IwIZAZWroeqUGdetQyzpJfqq', '[]', '[{\"number\":\"(62) 98193-6169\",\"name\":\"Whatsapp\"}]', '031.362.101-23', '5112608', 'M', '1989-07-27', '2', '3', 'Brasileiro', 'Brasil', 'Desenvolvedor Web Full-stack, Analista de Marketing Digital, SEO.', '1', NULL, '2025-08-22 19:21:14', '2025-08-22 19:23:10', NULL);

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activities_activityable_type_activityable_id_index` (`activityable_type`,`activityable_id`),
  ADD KEY `activities_user_id_foreign` (`user_id`),
  ADD KEY `activities_business_id_foreign` (`business_id`);

--
-- Índices para tabela `activity_crm_contact`
--
ALTER TABLE `activity_crm_contact`
  ADD UNIQUE KEY `activity_contact_unique` (`activity_id`,`contact_id`),
  ADD KEY `activity_crm_contact_contact_id_foreign` (`contact_id`);

--
-- Índices para tabela `activity_emails`
--
ALTER TABLE `activity_emails`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subject` (`subject_type`,`subject_id`),
  ADD KEY `causer` (`causer_type`,`causer_id`),
  ADD KEY `activity_log_log_name_index` (`log_name`);

--
-- Índices para tabela `activity_notes`
--
ALTER TABLE `activity_notes`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `activity_tasks`
--
ALTER TABLE `activity_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activity_tasks_task_id_foreign` (`task_id`);

--
-- Índices para tabela `activity_user`
--
ALTER TABLE `activity_user`
  ADD UNIQUE KEY `activity_user_unique` (`activity_id`,`user_id`),
  ADD KEY `activity_user_user_id_foreign` (`user_id`);

--
-- Índices para tabela `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addresses_addressable_type_addressable_id_index` (`addressable_type`,`addressable_id`);

--
-- Índices para tabela `agencies`
--
ALTER TABLE `agencies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `agencies_slug_unique` (`slug`);

--
-- Índices para tabela `agency_user`
--
ALTER TABLE `agency_user`
  ADD UNIQUE KEY `agency_user_unique` (`agency_id`,`user_id`),
  ADD KEY `agency_user_user_id_foreign` (`user_id`);

--
-- Índices para tabela `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Índices para tabela `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Índices para tabela `crm_business`
--
ALTER TABLE `crm_business`
  ADD PRIMARY KEY (`id`),
  ADD KEY `crm_business_user_id_foreign` (`user_id`),
  ADD KEY `crm_business_contact_id_foreign` (`contact_id`),
  ADD KEY `crm_business_funnel_id_foreign` (`funnel_id`),
  ADD KEY `crm_business_funnel_stage_id_foreign` (`funnel_stage_id`),
  ADD KEY `crm_business_funnel_substage_id_foreign` (`funnel_substage_id`),
  ADD KEY `crm_business_source_id_foreign` (`source_id`);

--
-- Índices para tabela `crm_business_funnel_stages`
--
ALTER TABLE `crm_business_funnel_stages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `crm_business_funnel_stages_business_id_foreign` (`business_id`),
  ADD KEY `crm_business_funnel_stages_funnel_id_foreign` (`funnel_id`),
  ADD KEY `crm_business_funnel_stages_funnel_stage_id_foreign` (`funnel_stage_id`),
  ADD KEY `crm_business_funnel_stages_funnel_substage_id_foreign` (`funnel_substage_id`);

--
-- Índices para tabela `crm_business_user`
--
ALTER TABLE `crm_business_user`
  ADD KEY `crm_business_user_business_id_foreign` (`business_id`),
  ADD KEY `crm_business_user_user_id_foreign` (`user_id`);

--
-- Índices para tabela `crm_contacts`
--
ALTER TABLE `crm_contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `contactable_unique` (`contactable_id`,`contactable_type`),
  ADD UNIQUE KEY `email_user_contactable_unique` (`email`,`user_id`,`contactable_type`),
  ADD KEY `crm_contacts_contactable_type_contactable_id_index` (`contactable_type`,`contactable_id`),
  ADD KEY `crm_contacts_user_id_foreign` (`user_id`),
  ADD KEY `crm_contacts_source_id_foreign` (`source_id`);

--
-- Índices para tabela `crm_contact_crm_contact_role`
--
ALTER TABLE `crm_contact_crm_contact_role`
  ADD UNIQUE KEY `contact_role_unique` (`contact_id`,`role_id`),
  ADD KEY `crm_contact_crm_contact_role_role_id_foreign` (`role_id`);

--
-- Índices para tabela `crm_contact_individuals`
--
ALTER TABLE `crm_contact_individuals`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `crm_contact_individual_crm_contact_legal_entity`
--
ALTER TABLE `crm_contact_individual_crm_contact_legal_entity`
  ADD UNIQUE KEY `individual_legal_entity_unique` (`individual_id`,`legal_entity_id`),
  ADD KEY `legal_entity_foreign` (`legal_entity_id`);

--
-- Índices para tabela `crm_contact_legal_entities`
--
ALTER TABLE `crm_contact_legal_entities`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `crm_contact_roles`
--
ALTER TABLE `crm_contact_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `crm_contact_roles_slug_unique` (`slug`);

--
-- Índices para tabela `crm_funnels`
--
ALTER TABLE `crm_funnels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `crm_funnels_slug_unique` (`slug`);

--
-- Índices para tabela `crm_funnel_stages`
--
ALTER TABLE `crm_funnel_stages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `crm_funnel_stages_slug_unique` (`slug`),
  ADD KEY `crm_funnel_stages_funnel_id_foreign` (`funnel_id`);

--
-- Índices para tabela `crm_funnel_substages`
--
ALTER TABLE `crm_funnel_substages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `crm_funnel_substages_slug_unique` (`slug`),
  ADD KEY `crm_funnel_substages_funnel_stage_id_foreign` (`funnel_stage_id`);

--
-- Índices para tabela `crm_sources`
--
ALTER TABLE `crm_sources`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `crm_sources_slug_unique` (`slug`);

--
-- Índices para tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Índices para tabela `financial_bank_accounts`
--
ALTER TABLE `financial_bank_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `financial_bank_accounts_bank_institution_id_foreign` (`bank_institution_id`),
  ADD KEY `financial_bank_accounts_agency_id_foreign` (`agency_id`);

--
-- Índices para tabela `financial_bank_institutions`
--
ALTER TABLE `financial_bank_institutions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `financial_bank_institutions_code_unique` (`code`),
  ADD UNIQUE KEY `financial_bank_institutions_ispb_unique` (`ispb`);

--
-- Índices para tabela `financial_categories`
--
ALTER TABLE `financial_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `financial_categories_slug_unique` (`slug`),
  ADD KEY `financial_categories_category_id_foreign` (`category_id`);

--
-- Índices para tabela `financial_category_financial_transaction`
--
ALTER TABLE `financial_category_financial_transaction`
  ADD UNIQUE KEY `transaction_category_unique` (`category_id`,`transaction_id`),
  ADD KEY `financial_category_financial_transaction_transaction_id_foreign` (`transaction_id`);

--
-- Índices para tabela `financial_transactions`
--
ALTER TABLE `financial_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `financial_transactions_user_id_foreign` (`user_id`),
  ADD KEY `financial_transactions_bank_account_id_foreign` (`bank_account_id`),
  ADD KEY `financial_transactions_contact_id_foreign` (`contact_id`),
  ADD KEY `financial_transactions_business_id_foreign` (`business_id`),
  ADD KEY `financial_transactions_transaction_id_foreign` (`transaction_id`);

--
-- Índices para tabela `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Índices para tabela `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `media_uuid_unique` (`uuid`),
  ADD KEY `media_model_type_model_id_index` (`model_type`,`model_id`),
  ADD KEY `media_order_column_index` (`order_column`);

--
-- Índices para tabela `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Índices para tabela `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Índices para tabela `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Índices para tabela `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Índices para tabela `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Índices para tabela `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Índices para tabela `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Índices para tabela `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `teams_slug_unique` (`slug`),
  ADD KEY `teams_agency_id_foreign` (`agency_id`);

--
-- Índices para tabela `team_user`
--
ALTER TABLE `team_user`
  ADD UNIQUE KEY `team_user_unique` (`team_id`,`user_id`,`role`),
  ADD KEY `team_user_user_id_foreign` (`user_id`);

--
-- Índices para tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `activities`
--
ALTER TABLE `activities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `activity_emails`
--
ALTER TABLE `activity_emails`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=434;

--
-- AUTO_INCREMENT de tabela `activity_notes`
--
ALTER TABLE `activity_notes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `activity_tasks`
--
ALTER TABLE `activity_tasks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `agencies`
--
ALTER TABLE `agencies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `crm_business`
--
ALTER TABLE `crm_business`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `crm_business_funnel_stages`
--
ALTER TABLE `crm_business_funnel_stages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `crm_contacts`
--
ALTER TABLE `crm_contacts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de tabela `crm_contact_individuals`
--
ALTER TABLE `crm_contact_individuals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `crm_contact_legal_entities`
--
ALTER TABLE `crm_contact_legal_entities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `crm_contact_roles`
--
ALTER TABLE `crm_contact_roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `crm_funnels`
--
ALTER TABLE `crm_funnels`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `crm_funnel_stages`
--
ALTER TABLE `crm_funnel_stages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de tabela `crm_funnel_substages`
--
ALTER TABLE `crm_funnel_substages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de tabela `crm_sources`
--
ALTER TABLE `crm_sources`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `financial_bank_accounts`
--
ALTER TABLE `financial_bank_accounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `financial_bank_institutions`
--
ALTER TABLE `financial_bank_institutions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=350;

--
-- AUTO_INCREMENT de tabela `financial_categories`
--
ALTER TABLE `financial_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `financial_transactions`
--
ALTER TABLE `financial_transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=326;

--
-- AUTO_INCREMENT de tabela `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `media`
--
ALTER TABLE `media`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de tabela `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT de tabela `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `teams`
--
ALTER TABLE `teams`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `activities_business_id_foreign` FOREIGN KEY (`business_id`) REFERENCES `crm_business` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `activities_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `activity_crm_contact`
--
ALTER TABLE `activity_crm_contact`
  ADD CONSTRAINT `activity_crm_contact_activity_id_foreign` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `activity_crm_contact_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `crm_contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `activity_tasks`
--
ALTER TABLE `activity_tasks`
  ADD CONSTRAINT `activity_tasks_task_id_foreign` FOREIGN KEY (`task_id`) REFERENCES `activity_tasks` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `activity_user`
--
ALTER TABLE `activity_user`
  ADD CONSTRAINT `activity_user_activity_id_foreign` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `activity_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `agency_user`
--
ALTER TABLE `agency_user`
  ADD CONSTRAINT `agency_user_agency_id_foreign` FOREIGN KEY (`agency_id`) REFERENCES `agencies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `agency_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `crm_business`
--
ALTER TABLE `crm_business`
  ADD CONSTRAINT `crm_business_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `crm_contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_business_funnel_id_foreign` FOREIGN KEY (`funnel_id`) REFERENCES `crm_funnels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_business_funnel_stage_id_foreign` FOREIGN KEY (`funnel_stage_id`) REFERENCES `crm_funnel_stages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_business_funnel_substage_id_foreign` FOREIGN KEY (`funnel_substage_id`) REFERENCES `crm_funnel_substages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_business_source_id_foreign` FOREIGN KEY (`source_id`) REFERENCES `crm_sources` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_business_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `crm_business_funnel_stages`
--
ALTER TABLE `crm_business_funnel_stages`
  ADD CONSTRAINT `crm_business_funnel_stages_business_id_foreign` FOREIGN KEY (`business_id`) REFERENCES `crm_business` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_business_funnel_stages_funnel_id_foreign` FOREIGN KEY (`funnel_id`) REFERENCES `crm_funnels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_business_funnel_stages_funnel_stage_id_foreign` FOREIGN KEY (`funnel_stage_id`) REFERENCES `crm_funnel_stages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_business_funnel_stages_funnel_substage_id_foreign` FOREIGN KEY (`funnel_substage_id`) REFERENCES `crm_funnel_substages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `crm_business_user`
--
ALTER TABLE `crm_business_user`
  ADD CONSTRAINT `crm_business_user_business_id_foreign` FOREIGN KEY (`business_id`) REFERENCES `crm_business` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_business_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `crm_contacts`
--
ALTER TABLE `crm_contacts`
  ADD CONSTRAINT `crm_contacts_source_id_foreign` FOREIGN KEY (`source_id`) REFERENCES `crm_sources` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_contacts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `crm_contact_crm_contact_role`
--
ALTER TABLE `crm_contact_crm_contact_role`
  ADD CONSTRAINT `crm_contact_crm_contact_role_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `crm_contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `crm_contact_crm_contact_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `crm_contact_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `crm_contact_individual_crm_contact_legal_entity`
--
ALTER TABLE `crm_contact_individual_crm_contact_legal_entity`
  ADD CONSTRAINT `individual_foreign` FOREIGN KEY (`individual_id`) REFERENCES `crm_contact_individuals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `legal_entity_foreign` FOREIGN KEY (`legal_entity_id`) REFERENCES `crm_contact_legal_entities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `crm_funnel_stages`
--
ALTER TABLE `crm_funnel_stages`
  ADD CONSTRAINT `crm_funnel_stages_funnel_id_foreign` FOREIGN KEY (`funnel_id`) REFERENCES `crm_funnels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `crm_funnel_substages`
--
ALTER TABLE `crm_funnel_substages`
  ADD CONSTRAINT `crm_funnel_substages_funnel_stage_id_foreign` FOREIGN KEY (`funnel_stage_id`) REFERENCES `crm_funnel_stages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `financial_bank_accounts`
--
ALTER TABLE `financial_bank_accounts`
  ADD CONSTRAINT `financial_bank_accounts_agency_id_foreign` FOREIGN KEY (`agency_id`) REFERENCES `agencies` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `financial_bank_accounts_bank_institution_id_foreign` FOREIGN KEY (`bank_institution_id`) REFERENCES `financial_bank_institutions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `financial_categories`
--
ALTER TABLE `financial_categories`
  ADD CONSTRAINT `financial_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `financial_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `financial_category_financial_transaction`
--
ALTER TABLE `financial_category_financial_transaction`
  ADD CONSTRAINT `financial_category_financial_transaction_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `financial_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `financial_category_financial_transaction_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `financial_transactions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `financial_transactions`
--
ALTER TABLE `financial_transactions`
  ADD CONSTRAINT `financial_transactions_bank_account_id_foreign` FOREIGN KEY (`bank_account_id`) REFERENCES `financial_bank_accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `financial_transactions_business_id_foreign` FOREIGN KEY (`business_id`) REFERENCES `crm_business` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `financial_transactions_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `crm_contacts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `financial_transactions_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `financial_transactions` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `financial_transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `teams_agency_id_foreign` FOREIGN KEY (`agency_id`) REFERENCES `agencies` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `team_user`
--
ALTER TABLE `team_user`
  ADD CONSTRAINT `team_user_team_id_foreign` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `team_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
