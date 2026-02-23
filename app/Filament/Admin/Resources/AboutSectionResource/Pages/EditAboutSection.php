<?php

namespace App\Filament\Admin\Resources\AboutSectionResource\Pages;

use App\Filament\Admin\Resources\AboutSectionResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditAboutSection extends EditRecord
{
    protected static string $resource = AboutSectionResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
