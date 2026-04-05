<?php

namespace App\Filament\Admin\Resources;

use App\Filament\Admin\Resources\GalleryItemResource\Pages;
use App\Filament\Admin\Resources\GalleryItemResource\RelationManagers;
use App\Models\GalleryItem;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class GalleryItemResource extends Resource
{
    protected static ?string $model = GalleryItem::class;

    protected static ?string $navigationIcon = 'heroicon-o-rectangle-stack';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make('Gallery Item')
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->label('Title')
                            ->required()
                            ->maxLength(255),

                        Forms\Components\Select::make('type')
                            ->label('Type')
                            ->options([
                                'image' => 'Image',
                                'video' => 'Video',
                            ])
                            ->required()
                            ->reactive(),

                        Forms\Components\FileUpload::make('image')
                            ->label('Image File')
                            ->image()
                            ->directory('gallery')
                            ->maxSize(5120)
                            ->required(fn (callable $get) => $get('type') === 'image')
                            ->visible(fn (callable $get) => $get('type') === 'image'),

                        Forms\Components\TextInput::make('video_url')
                            ->label('Video URL')
                            ->url()
                            ->maxLength(255)
                            ->required(fn (callable $get) => $get('type') === 'video')
                            ->visible(fn (callable $get) => $get('type') === 'video'),
                    ]),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('title')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\BadgeColumn::make('type')
                    ->colors([
                        'primary' => 'image',
                        'secondary' => 'video',
                    ]),
                Tables\Columns\TextColumn::make('image')
                    ->label('Image')
                    ->limit(30),
                Tables\Columns\TextColumn::make('video_url')
                    ->label('Video URL')
                    ->limit(40),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListGalleryItems::route('/'),
            'create' => Pages\CreateGalleryItem::route('/create'),
            'edit' => Pages\EditGalleryItem::route('/{record}/edit'),
        ];
    }
}
