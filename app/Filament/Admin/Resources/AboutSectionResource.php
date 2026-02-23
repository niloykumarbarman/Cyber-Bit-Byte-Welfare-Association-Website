<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\AboutSectionResource\Pages;
use App\Models\AboutSection;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class AboutSectionResource extends Resource
{
    protected static ?string $model = AboutSection::class;

    protected static ?string $navigationGroup = 'Website';
    protected static ?string $navigationLabel = 'About Us';
    protected static ?string $navigationIcon = 'heroicon-o-information-circle';

    public static function form(Form $form): Form
    {
        return $form->schema([
            Forms\Components\TextInput::make('title')->maxLength(255),
            Forms\Components\RichEditor::make('description')->columnSpanFull(),

            Forms\Components\FileUpload::make('image')
                ->image()
                ->directory('about')
                ->imageEditor(),

            Forms\Components\Toggle::make('is_active')->default(true),
            Forms\Components\TextInput::make('sort_order')->numeric()->default(0),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table->columns([
            Tables\Columns\ImageColumn::make('image')->circular(),
            Tables\Columns\TextColumn::make('title')->searchable(),
            Tables\Columns\IconColumn::make('is_active')->boolean(),
            Tables\Columns\TextColumn::make('sort_order')->sortable(),
        ])
        ->defaultSort('sort_order')
        ->actions([
            Tables\Actions\EditAction::make(),
            Tables\Actions\DeleteAction::make(),
        ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ManageAboutSections::route('/'),
        ];
    }
}
