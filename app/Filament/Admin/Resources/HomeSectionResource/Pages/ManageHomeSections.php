<?php

namespace App\Filament\Admin\Resources\HomeSectionResource\Pages;

use App\Filament\Admin\Resources\HomeSectionResource;
use Filament\Actions;
use Filament\Resources\Pages\ManageRecords;

class ManageHomeSections extends ManageRecords
{
    protected static string $resource = HomeSectionResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
