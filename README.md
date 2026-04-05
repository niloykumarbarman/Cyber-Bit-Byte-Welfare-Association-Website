<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## Cyber-Bit Byte Welfare Association Website

A modern Laravel 10 application with Filament Admin Panel for managing the welfare association website.

### Features

- **Filament Admin Panel** - Comprehensive admin interface for managing content
- **Gallery Management** - Upload and manage gallery items (images and videos)
- **Notice Management** - Create and publish notices with attachments
- **Publication Management** - Manage publications and documents
- **Member Management** - Maintain member profiles with photos
- **About Us Sections** - Dynamic about page content management
- **Contact Information** - Manage contact details
- **Executive Committee** - Track committee members
- **Automated CI/CD** - GitHub Actions for testing and deployment

### Database Models

- **AboutSection**
- **ContactInfo**
- **ExecutiveCommitteeMember**
- **GalleryItem**
- **HomeSection**
- **Member**
- **Notice**
- **Publication**
- **User**

### Recent Migrations

- `2026_04_05_000003_rename_publication_description.php`
- `2026_04_05_000002_rename_notice_columns.php`
- `2026_04_05_000001_nullable_gallery_image.php`
- `2026_04_05_000000_add_gallery_item_fields.php`
- `2026_02_23_100826_create_contact_infos_table.php`

### Installation & Setup

1. Clone the repository
2. Copy `.env.example` to `.env`
3. Run `composer install`
4. Generate key: `php artisan key:generate`
5. Setup database and run migrations: `php artisan migrate`
6. Build assets: `npm run build`
7. Start server: `php artisan serve`

### Admin Panel Access

The Filament Admin Panel is accessible at `/admin` once authenticated.

Manage:
- Gallery Items
- Notices
- Publications
- Members
- About Sections
- Contact Information
- Executive Committee Members

### Deployment

This project uses GitHub Actions for automated testing and deployment.

**Workflows:**
- **Tests** - Run on every push and pull request
- **Deploy** - Automatic deployment to production on main branch
- **Security** - Regular security scanning
- **Backup** - Automated database backups before deployment
- **Auto-README** - Automatic documentation updates

### Author

**Niloy Kumar Barman**

### License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).