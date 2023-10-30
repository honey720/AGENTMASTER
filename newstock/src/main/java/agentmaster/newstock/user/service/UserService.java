package agentmaster.newstock.user.service;

import agentmaster.newstock.dto.stockPage.mainPage.UserRanking;
import agentmaster.newstock.ranking.dto.RankingResponse;
import agentmaster.newstock.ranking.entity.Ranking;
import agentmaster.newstock.user.entitiy.User;
import agentmaster.newstock.user.exception.PasswordMismatchException;
import agentmaster.newstock.user.exception.UserDuplicateException;
import agentmaster.newstock.user.repository.UserRepository;
import agentmaster.newstock.user.repository.UserRepositoryImpl;
import agentmaster.newstock.user.request.SigninRequest;
import agentmaster.newstock.user.request.SignupRequest;
import agentmaster.newstock.user.response.SigninResponse;
import agentmaster.newstock.user.response.SignupResponse;
import agentmaster.newstock.user.response.UserDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;

    public List<UserDto> getUsers() {
        return userRepository.findAllFetch()
                .stream()
                .map(UserDto::new)
                .collect(Collectors.toList());
    }

    public UserDto getUser(String userName) {
        return new UserDto(userRepository.findByNameFetch(userName));
    }

    public UserRanking getRankByName(UserDto userDto) {
        User user = userRepository.findByName(userDto.getName());
        UserRanking userRanking = UserRanking.builder()
                .userName(user.getName())
                .rankRange(user.getRanking().getProfit())
                .ranking(user.getRanking().getRank())
                .build();
        return userRanking;
    }

    public SignupResponse signup(SignupRequest signupRequest) {
        if (userRepository.existsByName(signupRequest.getName())) {
            throw new UserDuplicateException();
        }

        Ranking ranking = Ranking.builder()
                .rank((int) userRepository.count() + 1)
                .profit(0.0)
                .build();

        User user = User.builder()
                .name(signupRequest.getName())
                .password(signupRequest.getPassword())
                .email(signupRequest.getEmail())
                .availableAsset(signupRequest.getAvailableAsset())
                .stockMoney(signupRequest.getStockMoney())
                .role("ROLE_USER")
                .ranking(ranking)
                .build();

        User result = userRepository.save(user);

        return new SignupResponse(result.getId());
    }

    public SigninResponse signin(SigninRequest signinRequest) {
        User user = userRepository.findByName(signinRequest.getName());
        checkPassword(signinRequest.getPassword(), user.getPassword());

        return new SigninResponse(user.getName());
    }

    private void checkPassword(String loginPassword, String password) {
        if (!(loginPassword.equals(password))) {
            throw new PasswordMismatchException();
        }
    }
}
