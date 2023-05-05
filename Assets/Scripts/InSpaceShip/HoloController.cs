using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoloController : MonoBehaviour
{
    public FinishTask1 quest;
    public float controllerStayTime;
    private bool isControllerClosed = false;

    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("hand"))
        {
            if (quest.isStarted && !isControllerClosed)
            {
                isControllerClosed = true;
                GetComponent<Collider>().enabled = false;
                StartCoroutine(CloseController());
                quest.EndQuest();
            }

        }
    }

    private IEnumerator CloseController()
    {
        yield return new WaitForSeconds(controllerStayTime);
        GetComponent<MeshRenderer>().enabled = false;
    }
}
