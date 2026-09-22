---
"dextinity-api": minor
---

Add `onePasswordSecrets`, which creates Kubernetes Secrets via the 1Password Kubernetes Operator and maps individual fields to container env vars. It parses 1Password secret reference URIs (`op://vault/item/[section/]field`); entries referencing the same vault/item share a single generated Secret.
