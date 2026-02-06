# Changelog

All notable changes to Royals will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-06

### Added
- エージェント定義にカラー属性を追加
- Rook タスク分解ルールの明確化
  - タスク粒度の原則（1 Pawn × 1 Quest で完了できる粒度）
  - `addBlockedBy` による正確な依存関係設定の義務化
  - description 必須項目の定義（参照ファイル・作成ファイル・完了条件・注意事項）
  - description 記述例の追加
- Crown スキルに Rook への伝達事項を追加

## [1.0.0] - 2026-02-04

### Added
- Initial release of Royals
- Queen (♛) as main orchestrator
- Piece roles: Rook (♜), Bishop (♝), Knight (♞), Pawn (♟)
- Skills: `/crown`, `/summon`, `/kingdom`, `/execution`
- Experience and level system for pieces
- Aptitude system for task assignment optimization
- Kingdom state management via YAML files
- Hooks for automatic agent registration and token tracking
- JSON Schema validation for kingdom files

### Features
- Chess-themed multi-agent management
- Parallel task execution with specialized agents
- Quest history tracking with verdict scoring
- Execution records for accountability
