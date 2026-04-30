# Repository Sanitization Checklist

Use this before making any real source repository public.

## Do Not Publish Until These Are Clean

- `.env`, `.env.local`, `.env.production`, Vercel environment references
- API keys, tokens, credentials, webhook URLs, database URLs
- Client names, emails, phone numbers, addresses, project IDs
- Pricing details that should not be public
- Internal comments, TODOs, logs, prompts, or operational notes
- Workflow exports containing endpoints, IDs, credentials, or business logic that should stay private
- Screenshots with customer data or private dashboards
- Commit history containing any of the above

## Required Checks

1. Run a secret scanner such as Gitleaks or TruffleHog.
2. Review `.gitignore`.
3. Review commit history, not only the latest files.
4. Remove or rewrite sensitive history if needed.
5. Rotate any credential that was ever committed.
6. Replace real data with fixtures.
7. Replace private endpoints with examples.
8. Add a public README that explains the project without exposing internals.
9. Add screenshots only after blurring private data.
10. Confirm repository visibility only after the review is complete.

## Safer Alternative

Instead of publishing the full source, create public case-study repositories with:

- README
- screenshots
- architecture diagram
- demo video link
- live site link
- clear statement that source is private and available on request after review

