<?php

namespace App\Filament\Admin\Resources\PublicationResource\Pages;

use App\Filament\Admin\Resources\PublicationResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreatePublication extends CreateRecord
{
    protected static string $resource = PublicationResource::class;
}
