//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import StreamChatUI
import SwiftUI

struct MessengerChatChannelListItem: ChatChannelListItemView.SwiftUIView {
    @EnvironmentObject var components: Components.ObservableObject
    @ObservedObject var dataSource: ChatChannelListItemView.ObservedObject<Self>
    init(dataSource: _ChatChannelListItemView<NoExtraData>.ObservedObject<MessengerChatChannelListItem>) {
        self.dataSource = dataSource
    }
    
    typealias ExtraData = NoExtraData
    
    var body: some View {
        HStack {
            components
                .channelList
                .itemSubviews
                .avatarView
                .asView((dataSource.content, dataSource.content?.membership?.id))
                .frame(width: 50, height: 50)
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                Text(dataSource.titleText ?? "")
                    .font(.system(.body))
                Text(
                    (dataSource.subtitleText ?? "")
                        + " • "
                        + (dataSource.timestampText ?? "")
                )
                .font(.system(.footnote))
                .foregroundColor(Color.gray)
            }
            
            Spacer()
        }
        .padding()
    }

    private func imageURL() -> URL? {
        guard let channel = dataSource.content else { return nil }
        if let avatarURL = channel.imageURL {
            return avatarURL
        }

        let firstOtherMember = channel.cachedMembers
            .sorted { $0.memberCreatedAt < $1.memberCreatedAt }
            .first(where: { $0.id != dataSource.content?.membership?.id })

        return firstOtherMember?.imageURL
    }
}
