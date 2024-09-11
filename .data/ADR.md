# Architectural Decision Records (ADR)

#### ADR 1: **Use of Ruby on Rails for Backend Framework**

**Context:**
We need a robust and scalable backend framework to support our core logic, admin panel, and GitHub app integrations.

**Decision:**
Ruby on Rails was chosen as the backend framework.

**Consequences:**
- Quick development with built-in conventions and libraries.
- Rich ecosystem for building and maintaining complex web applications.
- Good integration with ActiveAdmin, Sidekiq, and Redis for admin panel and background jobs.
- It may require optimization as traffic and application complexity scale up.

---

#### ADR 2: **Use of Sidekiq for Background Processing**

**Context:**
The application needs to handle background jobs, such as processing GitHub webhooks and generating review prompts via Ollama, efficiently.

**Decision:**
Sidekiq was selected for background job processing.

**Consequences:**
- Supports Redis, enabling fast and efficient background job processing.
- Integration with Rails is seamless, allowing easy queuing of jobs.
- Provides monitoring and retry mechanisms for handling failures.
- Requires Redis as a dependency.

---

#### ADR 3: **Use of PostgreSQL for Database**

**Context:**
We need a relational database to handle structured data for the application, such as user configurations, pull request metadata, and admin data.

**Decision:**
PostgreSQL was chosen as the relational database.

**Consequences:**
- Provides robust ACID compliance and transaction management.
- Advanced features like full-text search and JSON support for flexibility.
- Scalable for future data growth and complexity.
- Requires careful indexing and query optimization as the data grows.

---

#### ADR 4: **Use of Redis for Caching and Sidekiq Job Management**

**Context:**
We need a high-performance cache and job queue to manage Sidekiq background jobs and store temporary data.

**Decision:**
Redis was selected as the caching layer and job queue store.

**Consequences:**
- In-memory data store ensures fast access times for caching and job processing.
- Allows scaling background jobs efficiently.
- Requires dedicated memory management and monitoring to avoid performance bottlenecks.

---

#### ADR 5: **ActiveAdmin for Admin Panel**

**Context:**
The application requires an admin panel for configuring the Ollama prompts, managing GitHub app settings, and viewing job statuses.

**Decision:**
ActiveAdmin was chosen for building the admin interface.

**Consequences:**
- Provides an out-of-the-box solution for building administrative interfaces with Rails.
- Allows customization of forms, filters, and reports to suit business needs.
- Integrates well with the Rails ecosystem.
- May have limited customization compared to fully custom-built admin panels.

---

#### ADR 6: **Ollama Llama 3.1 for Reviewing Pull Requests**

**Context:**
The application needs an AI model to generate review feedback for pull requests based on configurable prompts.

**Decision:**
Ollama Llama 3.1 was chosen as the AI model for reviewing pull requests. Llama 3.1 is good at Kubernetes manifests and infrastructure code configuration generations. For example even closest  predecessor Llama 3 had some errors at generating Kubernetes manifests. So the newest one was chosen. Ollama was chosen as good choise for the local LLM as we do not want to send repositories data to third party LLM providers. Also it provides good level of customization for the LLM.

**Consequences:**
- State-of-the-art language model capable of understanding complex code and prompts.
- Allows configurable prompts to provide tailored feedback.
- Requires integration with background jobs to ensure scalability when handling multiple PRs.

---

#### ADR 7: **Integration with GitHub Apps**

**Context:**
The application needs to integrate directly with GitHub to automate PR reviews using webhooks.

**Decision:**
GitHub Apps integration was selected for handling PR reviews.

**Consequences:**
- Allows fine-grained permissions and webhook-based event handling for pull request triggers.
- Integrates with Sidekiq to perform background job processing.
- Enables automation of reviewing and interaction through GitHub's API.

---

### Key Decision Points Table

| **Name**                 | **Purpose and Pros**                                                                 |
|--------------------------|---------------------------------------------------------------------------------------|
| Ruby on Rails             | Quick development, rich ecosystem, and seamless integration with other components.    |
| Sidekiq                   | Efficient background job processing and retry management.                             |
| PostgreSQL                | Reliable relational database with advanced features like JSON support.                |
| Redis                     | In-memory caching and job queue management for Sidekiq.                              |
| ActiveAdmin               | Provides an out-of-the-box admin panel for configuration and management.              |
| Ollama Llama 3.1          | State-of-the-art language model for generating configurable PR review feedback.       |
| GitHub Apps               | Enables direct integration with GitHub for automated PR reviews via webhooks.         |


### Key Decision Points Table for Proposed Infrastructure Stack

| **Name**                 | **Purpose and Pros**                                                                  |
|--------------------------|---------------------------------------------------------------------------------------|
| Kubernetes                | For container orchestration, scaling, and management of microservices.                |
| Docker                    | Provides isolated environments for packaging and deploying applications.              |
| Helm                      | Simplifies Kubernetes deployments through package management (charts).               |
| Flux                      | Enables GitOps for continuous delivery, ensuring declarative infrastructure updates.  |
| Terraform                 | Infrastructure as Code (IaC) for provisioning and managing AWS resources.             |
| AWS                       | Provides scalable cloud infrastructure with services like EC2, RDS, S3, and more.     |