package kopo.poly.service.impl;

import kopo.poly.entity.SafetyAction;
import kopo.poly.entity.enums.ActionStatus;
import kopo.poly.repository.AiSafetyInspectionRepository;
import kopo.poly.repository.SafetyActionRepository;
import kopo.poly.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SafetyActionServiceTest {

    @Mock
    private SafetyActionRepository safetyActionRepository;

    @Mock
    private AiSafetyInspectionRepository inspectionRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private SafetyActionService safetyActionService;

    private SafetyAction action(ActionStatus status) {
        return SafetyAction.builder().id(1L).status(status).build();
    }

    @Test
    void updateStatus로는_완료_처리를_할_수_없다() {
        assertThrows(IllegalArgumentException.class, () -> safetyActionService.updateStatus(1L, ActionStatus.COMPLETED));
    }

    @Test
    void 진행중인_조치만_승인_요청할_수_있다() {
        SafetyAction requested = action(ActionStatus.REQUESTED);
        when(safetyActionRepository.findById(1L)).thenReturn(Optional.of(requested));

        assertThrows(IllegalArgumentException.class, () -> safetyActionService.submitForApproval(1L));
    }

    @Test
    void 진행중_조치는_승인요청하면_승인대기로_바뀐다() {
        SafetyAction inProgress = action(ActionStatus.IN_PROGRESS);
        when(safetyActionRepository.findById(1L)).thenReturn(Optional.of(inProgress));

        SafetyAction result = safetyActionService.submitForApproval(1L);

        assertThat(result.getStatus()).isEqualTo(ActionStatus.PENDING_APPROVAL);
    }

    @Test
    void 승인대기가_아니면_승인할_수_없다() {
        SafetyAction inProgress = action(ActionStatus.IN_PROGRESS);
        when(safetyActionRepository.findById(1L)).thenReturn(Optional.of(inProgress));

        assertThrows(IllegalArgumentException.class, () -> safetyActionService.approveCompletion(1L));
    }

    @Test
    void 승인대기_조치를_승인하면_완료로_바뀐다() {
        SafetyAction pending = action(ActionStatus.PENDING_APPROVAL);
        when(safetyActionRepository.findById(1L)).thenReturn(Optional.of(pending));

        SafetyAction result = safetyActionService.approveCompletion(1L);

        assertThat(result.getStatus()).isEqualTo(ActionStatus.COMPLETED);
    }

    @Test
    void 승인대기_조치를_반려하면_진행중으로_되돌아간다() {
        SafetyAction pending = action(ActionStatus.PENDING_APPROVAL);
        when(safetyActionRepository.findById(1L)).thenReturn(Optional.of(pending));

        SafetyAction result = safetyActionService.rejectCompletion(1L);

        assertThat(result.getStatus()).isEqualTo(ActionStatus.IN_PROGRESS);
    }
}
