<?php

namespace App\Filament\Admin\Resources\GalleryItemResource\Pages;

use App\Filament\Admin\Resources\GalleryItemResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditGalleryItem extends EditRecord
{
    protected static string $resource = GalleryItemResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
