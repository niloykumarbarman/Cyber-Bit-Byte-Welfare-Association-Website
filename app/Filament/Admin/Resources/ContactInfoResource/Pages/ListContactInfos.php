<?php

namespace App\Filament\Admin\Resources\ContactInfoResource\Pages;

use App\Filament\Admin\Resources\ContactInfoResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListContactInfos extends ListRecords
{
    protected static string $resource = ContactInfoResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
