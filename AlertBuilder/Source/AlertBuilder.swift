//
//  AlertController+Builder.swift
//  AlertBuilder
//
//  Created by Takehito Koshimizu on 2017/05/04.
//
//

import UIKit

public protocol _AlertBuilderState {}
/// アラートビルダーの状態
public enum AlertBuilderState {
    /// タイトルが設定可能な状態
    public struct Title: _AlertBuilderState {}
    /// メッセージが設定可能な状態
    public struct Message: _AlertBuilderState {}
    /// アラートアクションが設定可能な状態
    public struct Action: _AlertBuilderState {}
}

@available(iOS 8.0, *)
public final class Alert<Title, Message, ActionTitle>
    where Title: CustomStringConvertible,
    Message: CustomStringConvertible,
    ActionTitle: CustomStringConvertible {
}

extension Alert {

    /// アラートアクション
    public struct AlertAction {
        /// タイトル
        let title: ActionTitle
        /// スタイル
        let style: UIAlertActionStyle
        /// アクションを許可
        let isEnabled: Bool
    }

    /// ビルダー
    public struct Builder<T: _AlertBuilderState> {
        typealias State = T
        /// タイトル
        let title: Title?
        /// メッセージ
        let message: Message?
        /// スタイル
        let style: UIAlertControllerStyle?
        /// アラートアクション
        let actions: [AlertAction]
    }

    /// アラートのビルダー
    @available(iOS 8.0, *)
    public static var alertBuilder: Builder<AlertBuilderState.Title> {
        return .init(title: nil, message: nil, style: .alert, actions: [])
    }

    /// アクションシートのビルダー
    @available(iOS 8.0, *)
    public static var actionSheetBuilder: Builder<AlertBuilderState.Title> {
        return .init(title: nil, message: nil, style: .actionSheet, actions: [])
    }
}

extension Alert.Builder where T==AlertBuilderState.Title {

    /// タイトルを設定する
    public func title(_ title: Title? = nil) -> Alert<Title, Message, ActionTitle>.Builder<AlertBuilderState.Message> {
        return .init(title: title, message: message, style: style, actions: actions)
    }
}

extension Alert.Builder where T==AlertBuilderState.Message {

    /// メッセージを設定する
    public func message(_ message: Message? = nil) -> Alert<Title, Message, ActionTitle>.Builder<AlertBuilderState.Action> {
        return .init(title: title, message: message, style: style, actions: actions)
    }
}

extension Alert.Builder where T==AlertBuilderState.Action {

    /// アラートアクションを設定する
    public func action(style: UIAlertActionStyle = .default, title: ActionTitle, isEnabled: Bool = true) -> Alert<Title, Message, ActionTitle>.Builder<AlertBuilderState.Action> {
        let actions = self.actions+[.init(title: title, style: style, isEnabled: isEnabled)]
        return Alert.Builder<AlertBuilderState.Action>.init(title: self.title, message: self.message, style: self.style, actions: actions)
    }
}

extension Alert.Builder where T==AlertBuilderState.Action {

    /// アラートコントローラを生成する
    public func build(handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = self.alertController()
        self.alertActions(handler).forEach(alert.addAction)
        return alert
    }

    private func alertController() -> UIAlertController {
        return UIAlertController(title: title?.description, message: message?.description, preferredStyle: style ?? .alert)
    }

    private func alertActions(_ handler: @escaping ((UIAlertAction) -> Void)) -> [UIAlertAction] {
        return actions.map { UIAlertAction(title: $0.title.description, style: $0.style, handler: handler) }
    }
}
