<?php

namespace App\Filament\Admin\Resources\ContactInfoResource\Pages;

use App\Filament\Admin\Resources\ContactInfoResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateContactInfo extends CreateRecord
{
    protected static string $resource = ContactInfoResource::class;
}
