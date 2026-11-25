# ADR 0004: Store profile photos with Active Storage and S3

**Status:** Implemented; documented during Sprint 4.

## Context

Users can upload a profile photo. Photos need to remain available across application deployments, while the application needs to track which photo belongs to each profile.

The interface also needs useful alt text and a fallback when a profile has no photo.

## Decision

Use Rails Active Storage with one attachment per profile:

    has_one_attached :photo

Production uses the `amazon` storage service backed by Amazon S3.

PostgreSQL stores Active Storage blob and attachment metadata. S3 stores the photo files. Alt text is stored separately in `profiles.photo_alt_text`.

The profile model validates:

- JPG or PNG content type.
- File size no greater than 5 MB.
- Alt text whenever a photo is attached.

S3 credentials, bucket and region are supplied through environment variables. The storage configuration also defines disk services for local use and tests.

## Consequences

- Uploaded files are stored separately from the Rails application.
- Active Storage handles the association between a profile and its photo.
- Production requires working S3 configuration.
- Photo validation happens on the server.
- Views can show the uploaded photo with its alt text or the "No photo yet." fallback.

## References

- [Profile model](../../app/models/profile.rb)
- [Storage configuration](../../config/storage.yml)
- [Production configuration](../../config/environments/production.rb)
- [Database schema](../../db/schema.rb)
- [System architecture](../architecture.md)
- [Data model](../data-model.md)
